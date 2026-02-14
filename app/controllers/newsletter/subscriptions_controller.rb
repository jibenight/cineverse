module Newsletter
  class SubscriptionsController < ApplicationController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    def subscribe
      @subscriber = NewsletterSubscriber.find_or_initialize_by(email: params[:email])

      if @subscriber.new_record?
        @subscriber.assign_attributes(
          first_name: params[:first_name],
          source: current_user ? :signup : :footer_form,
          user: current_user,
          status: :pending
        )

        if @subscriber.save
          NewsletterMailer.confirmation_email(@subscriber).deliver_later
          respond_to do |format|
            format.turbo_stream { render turbo_stream: turbo_stream.replace("newsletter_form", html: tag.p("Un email de confirmation vous a été envoyé !", class: "text-green-500 text-sm")) }
            format.html { redirect_back fallback_location: root_path, notice: "Un email de confirmation vous a été envoyé !" }
          end
        else
          redirect_back fallback_location: root_path, alert: @subscriber.errors.full_messages.join(", ")
        end
      else
        redirect_back fallback_location: root_path, notice: "Cet email est déjà inscrit."
      end
    end

    def confirm
      subscriber = NewsletterSubscriber.find_by(confirmation_token: params[:token])

      if subscriber && subscriber.pending? && subscriber.created_at > 48.hours.ago
        subscriber.confirm!
        create_default_preferences(subscriber)
        redirect_to root_path, notice: I18n.t("newsletter.confirmed")
      else
        redirect_to root_path, alert: "Lien de confirmation invalide ou expiré."
      end
    end

    def unsubscribe
      subscriber = NewsletterSubscriber.find_by(confirmation_token: params[:token])

      if subscriber
        subscriber.unsubscribe!
        redirect_to root_path, notice: I18n.t("newsletter.unsubscribed")
      else
        redirect_to root_path, alert: "Lien de désinscription invalide."
      end
    end

    def preferences
      @subscriber = NewsletterSubscriber.find_by!(confirmation_token: params[:token])
      @preferences = @subscriber.newsletter_preferences
    end

    def update_preferences
      @subscriber = NewsletterSubscriber.find_by!(confirmation_token: params[:token])

      NewsletterPreference.categories.each_key do |category|
        pref = @subscriber.newsletter_preferences.find_or_initialize_by(category: category)
        pref.enabled = params.dig(:preferences, category) == "1"
        pref.save!
      end

      redirect_to newsletter_preferences_path(params[:token]), notice: "Préférences mises à jour !"
    end

    private

    def create_default_preferences(subscriber)
      NewsletterPreference.categories.each_key do |category|
        subscriber.newsletter_preferences.create!(category: category, enabled: true)
      end
    end
  end
end
