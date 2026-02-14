require 'rails_helper'

RSpec.describe NewsletterPreference, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:subscriber).class_name("NewsletterSubscriber") }
  end

  describe "validations" do
    it "enforces uniqueness of category per subscriber" do
      subscriber = create(:newsletter_subscriber)
      create(:newsletter_preference, subscriber: subscriber, category: :weekly_picks)
      duplicate = build(:newsletter_preference, subscriber: subscriber, category: :weekly_picks)
      expect(duplicate).not_to be_valid
    end
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:category).with_values(weekly_picks: 0, new_releases: 1, community_highlights: 2, deals: 3) }
  end
end
