require 'rails_helper'

RSpec.describe NewsletterCampaign, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:created_by).class_name("User") }
    it { is_expected.to have_one(:newsletter_campaign_stat).dependent(:destroy) }
    it { is_expected.to have_many(:newsletter_click_events).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:subject) }
    it { is_expected.to validate_presence_of(:body_html) }
  end

  describe "enums" do
    it {
      is_expected.to define_enum_for(:status).with_values(
        draft: 0, scheduled: 1, sending: 2, sent: 3, cancelled: 4
      )
    }
  end

  describe "#stats" do
    it "returns the campaign stat" do
      campaign = create(:newsletter_campaign)
      stat = create(:newsletter_campaign_stat, campaign: campaign)
      expect(campaign.stats).to eq(stat)
    end
  end
end
