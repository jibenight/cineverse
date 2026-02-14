module Newsletter
  class TrackingController < ApplicationController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    def click
      event = NewsletterClickEvent.find_by(id: params[:token])
      if event
        event.update(clicked_at: Time.current)
        stat = event.campaign.newsletter_campaign_stat
        stat&.increment!(:total_clicked)
      end
      redirect_to params[:url], allow_other_host: true, status: 302
    end

    def open
      # 1x1 transparent pixel tracking
      subscriber = NewsletterSubscriber.find_by(confirmation_token: params[:token])
      if subscriber && params[:campaign_id]
        stat = NewsletterCampaignStat.find_by(campaign_id: params[:campaign_id])
        stat&.increment!(:total_opened)
      end
      send_data Base64.decode64("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7"),
                type: "image/gif", disposition: "inline"
    end
  end
end
