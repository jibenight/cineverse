require 'rails_helper'

RSpec.describe "Admin Users", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:target_user) { create(:user) }

  before { sign_in admin }

  describe "GET /admin/users" do
    before { create_list(:user, 3) }

    it "returns success" do
      get admin_users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/users/:id" do
    it "returns success" do
      get admin_user_path(target_user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /admin/users/:id/ban" do
    it "bans the user" do
      post ban_admin_user_path(target_user), params: { ban_reason: "Spam" }
      expect(target_user.reload.banned?).to be true
    end

    it "creates an audit log" do
      expect {
        post ban_admin_user_path(target_user), params: { ban_reason: "Spam" }
      }.to change(AdminAuditLog, :count).by(1)
    end
  end

  describe "POST /admin/users/:id/unban" do
    let(:banned_user) { create(:user, :banned) }

    it "unbans the user" do
      post unban_admin_user_path(banned_user)
      expect(banned_user.reload.banned?).to be false
    end
  end

  describe "POST /admin/users/:id/promote_premium" do
    it "promotes user to premium" do
      post promote_premium_admin_user_path(target_user)
      expect(target_user.reload.role).to eq("premium")
    end
  end
end
