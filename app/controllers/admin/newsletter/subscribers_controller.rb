module Admin
  module Newsletter
    class SubscribersController < Admin::BaseController
      def index
        @subscribers = ::NewsletterSubscriber.all
        @subscribers = @subscribers.where(status: params[:status]) if params[:status].present?
        @subscribers = @subscribers.where(source: params[:source]) if params[:source].present?
        @pagy, @subscribers = pagy(@subscribers.order(created_at: :desc))
      end

      def show
        @subscriber = ::NewsletterSubscriber.find(params[:id])
      end

      def destroy
        @subscriber = ::NewsletterSubscriber.find(params[:id])
        audit_log!(action: "deleted_subscriber", target: @subscriber, metadata: { email: @subscriber.email })
        @subscriber.destroy
        redirect_to admin_newsletter_subscribers_path, notice: "Abonné supprimé."
      end

      def unsubscribe
        @subscriber = ::NewsletterSubscriber.find(params[:id])
        @subscriber.unsubscribe!
        audit_log!(action: "unsubscribed_subscriber", target: @subscriber)
        redirect_to admin_newsletter_subscribers_path, notice: "Abonné désinscrit."
      end

      def resend_confirmation
        @subscriber = ::NewsletterSubscriber.find(params[:id])
        ::NewsletterMailer.confirmation_email(@subscriber).deliver_later
        redirect_to admin_newsletter_subscribers_path, notice: "Email de confirmation renvoyé."
      end

      def export_csv
        subscribers = ::NewsletterSubscriber.all
        csv_data = CSV.generate(headers: true) do |csv|
          csv << %w[id email first_name status source subscribed_at unsubscribed_at]
          subscribers.find_each do |sub|
            csv << [sub.id, sub.email, sub.first_name, sub.status, sub.source, sub.subscribed_at, sub.unsubscribed_at]
          end
        end
        send_data csv_data, filename: "newsletter_subscribers_#{Date.current}.csv", type: "text/csv"
      end

      MAX_IMPORT_FILE_SIZE = 5.megabytes
      MAX_IMPORT_ROWS = 10_000

      def import_csv
        file = params[:file]
        unless file
          return redirect_to admin_newsletter_subscribers_path, alert: "Aucun fichier sélectionné."
        end

        if file.size > MAX_IMPORT_FILE_SIZE
          return redirect_to admin_newsletter_subscribers_path, alert: "Le fichier dépasse la taille maximale de 5 Mo."
        end

        row_count = 0
        ActiveRecord::Base.transaction do
          CSV.foreach(file.path, headers: true) do |row|
            row_count += 1
            if row_count > MAX_IMPORT_ROWS
              raise ActiveRecord::Rollback, "Trop de lignes (max #{MAX_IMPORT_ROWS})"
            end

            ::NewsletterSubscriber.find_or_create_by(email: row["email"]) do |sub|
              sub.first_name = row["first_name"]
              sub.source = :import
              sub.status = :pending
            end
          end
        end

        if row_count > MAX_IMPORT_ROWS
          redirect_to admin_newsletter_subscribers_path, alert: "Le fichier dépasse le maximum de #{MAX_IMPORT_ROWS} lignes."
        else
          audit_log!(action: "imported_subscribers", metadata: { filename: file.original_filename, row_count: row_count })
          redirect_to admin_newsletter_subscribers_path, notice: "Import terminé (#{row_count} lignes traitées)."
        end
      end
    end
  end
end
