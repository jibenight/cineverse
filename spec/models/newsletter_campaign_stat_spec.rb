require 'rails_helper'

RSpec.describe NewsletterCampaignStat, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:campaign).class_name("NewsletterCampaign") }
  end

  let(:stat) do
    build(:newsletter_campaign_stat,
      total_sent: 1000,
      total_opened: 350,
      total_clicked: 120,
      total_bounced: 10,
      total_unsubscribed: 5
    )
  end

  describe "#open_rate" do
    it "calculates open rate percentage" do
      expect(stat.open_rate).to eq(35.0)
    end

    it "returns 0 when total_sent is zero" do
      stat.total_sent = 0
      expect(stat.open_rate).to eq(0)
    end
  end

  describe "#click_rate" do
    it "calculates click rate percentage" do
      expect(stat.click_rate).to eq(12.0)
    end

    it "returns 0 when total_sent is zero" do
      stat.total_sent = 0
      expect(stat.click_rate).to eq(0)
    end
  end

  describe "#bounce_rate" do
    it "calculates bounce rate percentage" do
      expect(stat.bounce_rate).to eq(1.0)
    end
  end

  describe "#unsubscribe_rate" do
    it "calculates unsubscribe rate percentage" do
      expect(stat.unsubscribe_rate).to eq(0.5)
    end
  end
end
