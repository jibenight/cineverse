require 'rails_helper'

RSpec.describe UserBadge, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:badge) }
  end

  describe "validations" do
    subject { build(:user_badge, user: create(:user), badge: create(:badge)) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:badge_id) }
  end

  describe "callbacks" do
    it "creates a badge_earned notification" do
      user = create(:user)
      badge = create(:badge)
      expect { UserBadge.create!(user: user, badge: badge, earned_at: Time.current) }
        .to change(Notification, :count).by(1)
      expect(Notification.last.action).to eq("badge_earned")
    end
  end
end
