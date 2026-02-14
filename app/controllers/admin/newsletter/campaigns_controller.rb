module Admin
  module Newsletter
    class CampaignsController < Admin::BaseController
      def index
        @pagy, @campaigns = pagy(NewsletterCampaign.recent)
      end

      def show
        @campaign = NewsletterCampaign.find(params[:id])
        @stats = @campaign.stats
      end

      def new
        @campaign = NewsletterCampaign.new
      end

      def create
        @campaign = NewsletterCampaign.new(campaign_params.merge(created_by: current_user, status: :draft))
        if @campaign.save
          audit_log!(action: "created_campaign", target: @campaign)
          redirect_to admin_newsletter_campaign_path(@campaign), notice: "Campagne créée."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def update
        @campaign = NewsletterCampaign.find(params[:id])
        if @campaign.update(campaign_params)
          audit_log!(action: "updated_campaign", target: @campaign)
          redirect_to admin_newsletter_campaign_path(@campaign), notice: "Campagne mise à jour."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def send_campaign
        @campaign = NewsletterCampaign.find(params[:id])
        NewsletterSendService.new(@campaign).send_campaign
        audit_log!(action: "sent_campaign", target: @campaign)
        redirect_to admin_newsletter_campaign_path(@campaign), notice: "Campagne en cours d'envoi."
      end

      def cancel
        @campaign = NewsletterCampaign.find(params[:id])
        @campaign.update!(status: :cancelled)
        audit_log!(action: "cancelled_campaign", target: @campaign)
        redirect_to admin_newsletter_campaigns_path, notice: "Campagne annulée."
      end

      def duplicate
        original = NewsletterCampaign.find(params[:id])
        @campaign = original.dup
        @campaign.assign_attributes(status: :draft, subject: "Copie - #{original.subject}", sent_at: nil, scheduled_at: nil)
        @campaign.save!
        redirect_to edit_admin_newsletter_campaign_path(@campaign), notice: "Campagne dupliquée."
      end

      def preview
        @campaign = NewsletterCampaign.find(params[:id])
        render layout: false
      end

      private

      def campaign_params
        params.require(:newsletter_campaign).permit(:subject, :body_html, :body_text, :scheduled_at, :segment_filter)
      end
    end
  end
end
