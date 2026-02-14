require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:notifiable) }
  end

  describe "enums" do
    it {
      is_expected.to define_enum_for(:action).with_values(
        new_message: 0, new_follower: 1, new_like: 2,
        release_alert: 3, badge_earned: 4
      )
    }
  end

  describe "scopes" do
    let!(:unread) { create(:notification, read: false) }
    let!(:read_notif) { create(:notification, read: true) }

    it ".unread returns only unread notifications" do
      expect(Notification.unread).to include(unread)
      expect(Notification.unread).not_to include(read_notif)
    end

    it ".recent orders by created_at desc" do
      expect(Notification.recent.first.created_at).to be >= Notification.recent.last.created_at
    end
  end

  describe "#mark_as_read!" do
    it "sets read to true" do
      notification = create(:notification, read: false)
      notification.mark_as_read!
      expect(notification.reload.read).to be true
    end
  end
end
