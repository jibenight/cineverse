require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /notifications" do
    it "returns success" do
      get notifications_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /notifications/mark_all_read" do
    before do
      follow = create(:follow, followed: user)
      create(:notification, user: user, notifiable: follow, read: false)
    end

    it "marks all notifications as read" do
      post mark_all_read_notifications_path
      expect(user.notifications.unread.count).to eq(0)
    end
  end
end
