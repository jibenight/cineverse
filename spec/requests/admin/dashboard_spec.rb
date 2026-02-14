require 'rails_helper'

RSpec.describe "Admin Dashboard", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:user) { create(:user) }

  describe "GET /admin" do
    context "as admin" do
      before { sign_in admin }

      it "returns success" do
        get admin_root_path
        expect(response).to have_http_status(:success)
      end
    end

    context "as regular user" do
      before { sign_in user }

      it "denies access" do
        get admin_root_path
        expect(response).to have_http_status(:redirect)
      end
    end

    context "as guest" do
      it "redirects to login" do
        get admin_root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
