require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:follower).class_name("User") }
    it { is_expected.to belong_to(:followed).class_name("User") }
  end

  describe "validations" do
    subject { build(:follow) }

    it { is_expected.to validate_uniqueness_of(:follower_id).scoped_to(:followed_id) }

    it "cannot follow self" do
      user = create(:user)
      follow = build(:follow, follower: user, followed: user)
      expect(follow).not_to be_valid
      expect(follow.errors[:follower_id]).to include("cannot follow yourself")
    end
  end

  describe "callbacks" do
    it "creates a notification for the followed user" do
      expect { create(:follow) }.to change(Notification, :count).by(1)
    end

    it "creates a new_follower notification" do
      follow = create(:follow)
      notification = Notification.last
      expect(notification.user).to eq(follow.followed)
      expect(notification.action).to eq("new_follower")
      expect(notification.notifiable).to eq(follow)
    end
  end
end
