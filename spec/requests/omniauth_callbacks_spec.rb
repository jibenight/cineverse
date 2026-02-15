require 'rails_helper'

RSpec.describe "OmniAuth Callbacks", type: :request do
  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
    OmniAuth.config.mock_auth[:github] = nil
    OmniAuth.config.mock_auth[:apple] = nil
    Rails.application.env_config["omniauth.auth"] = nil
  end

  def mock_omniauth(provider, uid:, email:, name:, nickname: nil)
    auth_hash = OmniAuth::AuthHash.new(
      provider: provider.to_s,
      uid: uid,
      info: OmniAuth::AuthHash::InfoHash.new(
        { email: email, name: name, nickname: nickname }.compact
      )
    )
    OmniAuth.config.mock_auth[provider] = auth_hash
    Rails.application.env_config["omniauth.auth"] = auth_hash
  end

  describe "Google OAuth2" do
    before { mock_omniauth(:google_oauth2, uid: "google_123", email: "google_user@gmail.com", name: "Google User") }

    it "signs in the user and redirects" do
      get "/users/auth/google_oauth2/callback"
      expect(response).to redirect_to(root_path)
    end
  end

  describe "GitHub OAuth" do
    before { mock_omniauth(:github, uid: "github_456", email: "github_user@example.com", name: "GitHub User", nickname: "ghuser") }

    it "signs in the user and redirects" do
      get "/users/auth/github/callback"
      expect(response).to redirect_to(root_path)
    end
  end

  describe "Apple OAuth" do
    before { mock_omniauth(:apple, uid: "apple_789", email: "apple_user@icloud.com", name: "Apple User") }

    it "signs in the user and redirects" do
      get "/users/auth/apple/callback"
      expect(response).to redirect_to(root_path)
    end
  end

  describe "OAuth failure" do
    before do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    end

    it "redirects to root with an alert" do
      get "/users/auth/google_oauth2/callback"
      expect(response).to redirect_to(root_path)
    end
  end

  describe "linking to existing account" do
    let!(:existing_user) { create(:user, email: "existing@example.com") }

    before { mock_omniauth(:github, uid: "link_123", email: "existing@example.com", name: "Existing User") }

    it "links the OAuth provider to the existing account" do
      expect { get "/users/auth/github/callback" }.not_to change(User, :count)
      existing_user.reload
      expect(existing_user.provider).to eq("github")
      expect(existing_user.uid).to eq("link_123")
    end
  end
end
