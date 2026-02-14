require 'rails_helper'

RSpec.describe NewsletterSubscriber, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to have_many(:newsletter_preferences).dependent(:destroy) }
    it { is_expected.to have_many(:newsletter_click_events).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:newsletter_subscriber) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(pending: 0, active: 1, unsubscribed: 2, bounced: 3) }
    it { is_expected.to define_enum_for(:source).with_values(signup: 0, import: 1, manual: 2, footer_form: 3) }
  end

  describe "callbacks" do
    it "generates a confirmation_token before create" do
      subscriber = create(:newsletter_subscriber)
      expect(subscriber.confirmation_token).to be_present
    end
  end

  describe "#confirm!" do
    it "sets status to active and confirmed_at" do
      subscriber = create(:newsletter_subscriber, status: :pending)
      subscriber.confirm!
      expect(subscriber.reload.status).to eq("active")
      expect(subscriber.confirmed_at).to be_present
    end
  end

  describe "#unsubscribe!" do
    it "sets status to unsubscribed and unsubscribed_at" do
      subscriber = create(:newsletter_subscriber, :active)
      subscriber.unsubscribe!
      expect(subscriber.reload.status).to eq("unsubscribed")
      expect(subscriber.unsubscribed_at).to be_present
    end
  end

  describe "scopes" do
    it ".confirmed returns only active subscribers" do
      active = create(:newsletter_subscriber, :active)
      pending = create(:newsletter_subscriber, status: :pending)
      expect(NewsletterSubscriber.confirmed).to include(active)
      expect(NewsletterSubscriber.confirmed).not_to include(pending)
    end
  end
end
