require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET /profile/:username" do
    it "returns success" do
      get "/profile/#{other_user.username}", headers: { "HTTP_USER_AGENT" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /profile/:username/follow" do
    before { sign_in user }

    it "follows the user" do
      expect {
        post follow_user_path(other_user.username)
      }.to change(Follow, :count).by(1)
    end
  end

  describe "DELETE /profile/:username/unfollow" do
    before do
      sign_in user
      user.follow(other_user)
    end

    it "unfollows the user" do
      expect {
        delete unfollow_user_path(other_user.username)
      }.to change(Follow, :count).by(-1)
    end
  end
end
