require 'rails_helper'

RSpec.describe NewsletterSendService do
  let(:admin) { create(:user, :admin) }
  let(:campaign) { create(:newsletter_campaign, created_by: admin) }
  let(:service) { described_class.new(campaign) }

  describe "#send_campaign" do
    before do
      3.times { create(:newsletter_subscriber, :active) }
      allow_any_instance_of(described_class).to receive(:sleep)
    end

    it "updates campaign status to sending then sent" do
      service.send_campaign
      expect(campaign.reload.status).to eq("sent")
      expect(campaign.sent_at).to be_present
    end

    it "creates campaign stats" do
      expect { service.send_campaign }.to change(NewsletterCampaignStat, :count).by(1)
      stat = campaign.reload.stats
      expect(stat.total_sent).to eq(3)
    end

    it "sends emails via deliver_later for each active subscriber" do
      expect(NewsletterMailer).to receive(:campaign_email).exactly(3).times.and_call_original
      service.send_campaign
    end

    context "with segment filter" do
      it "filters by category preference" do
        subscriber_with_pref = create(:newsletter_subscriber, :active)
        create(:newsletter_preference, subscriber: subscriber_with_pref, category: :weekly_picks, enabled: true)

        campaign.update!(segment_filter: { "category" => "weekly_picks" })

        service.send_campaign
        stat = campaign.reload.stats
        expect(stat.total_sent).to eq(1)
      end
    end
  end
end
