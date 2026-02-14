require 'rails_helper'

RSpec.describe NewsletterCampaignPolicy do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:draft_campaign) { create(:newsletter_campaign, status: :draft, created_by: admin) }
  let(:sent_campaign) { create(:newsletter_campaign, :sent, created_by: admin) }
  let(:scheduled_campaign) { create(:newsletter_campaign, :scheduled, created_by: admin) }

  subject { described_class }

  describe "#index?" do
    it "allows admin" do
      expect(subject.new(admin, NewsletterCampaign)).to be_index
    end

    it "denies regular users" do
      expect(subject.new(user, NewsletterCampaign)).not_to be_index
    end
  end

  describe "#create?" do
    it "allows admin" do
      expect(subject.new(admin, NewsletterCampaign.new)).to be_create
    end

    it "denies regular users" do
      expect(subject.new(user, NewsletterCampaign.new)).not_to be_create
    end
  end

  describe "#update?" do
    it "allows admin to update draft campaigns" do
      expect(subject.new(admin, draft_campaign)).to be_update
    end

    it "allows admin to update scheduled campaigns" do
      expect(subject.new(admin, scheduled_campaign)).to be_update
    end

    it "denies updating sent campaigns" do
      expect(subject.new(admin, sent_campaign)).not_to be_update
    end
  end

  describe "#destroy?" do
    it "allows admin to destroy draft campaigns" do
      expect(subject.new(admin, draft_campaign)).to be_destroy
    end

    it "denies destroying sent campaigns" do
      expect(subject.new(admin, sent_campaign)).not_to be_destroy
    end
  end

  describe "#cancel?" do
    it "allows cancelling scheduled campaigns" do
      expect(subject.new(admin, scheduled_campaign)).to be_cancel
    end

    it "denies cancelling draft campaigns" do
      expect(subject.new(admin, draft_campaign)).not_to be_cancel
    end
  end
end
