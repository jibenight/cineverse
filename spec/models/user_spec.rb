require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:ratings).dependent(:destroy) }
    it { is_expected.to have_many(:rated_movies).through(:ratings) }
    it { is_expected.to have_many(:watchlist_items).dependent(:destroy) }
    it { is_expected.to have_many(:watchlisted_movies).through(:watchlist_items) }
    it { is_expected.to have_many(:active_follows).class_name("Follow").dependent(:destroy) }
    it { is_expected.to have_many(:passive_follows).class_name("Follow").dependent(:destroy) }
    it { is_expected.to have_many(:following).through(:active_follows) }
    it { is_expected.to have_many(:followers).through(:passive_follows) }
    it { is_expected.to have_many(:notifications).dependent(:destroy) }
    it { is_expected.to have_many(:user_badges).dependent(:destroy) }
    it { is_expected.to have_many(:badges).through(:user_badges) }
    it { is_expected.to have_many(:conversation_participants).dependent(:destroy) }
    it { is_expected.to have_many(:conversations).through(:conversation_participants) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
    it { is_expected.to have_many(:release_alerts).dependent(:destroy) }
    it { is_expected.to have_many(:affiliate_clicks).dependent(:destroy) }
    it { is_expected.to have_many(:cinema_passes).dependent(:destroy) }
    it { is_expected.to have_many(:user_discounts).dependent(:destroy) }
    it { is_expected.to have_many(:reports_made).class_name("Report").dependent(:destroy) }
    it { is_expected.to have_many(:mutes).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_length_of(:username).is_at_least(3).is_at_most(30) }
    it { is_expected.to validate_length_of(:bio).is_at_most(500) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:role).with_values(user: 0, premium: 1, admin: 2) }
    it { is_expected.to define_enum_for(:theme_preference).with_values(dark: 0, light: 1) }
  end

  describe "scopes" do
    let!(:active_user) { create(:user) }
    let!(:banned_user) { create(:user, :banned) }
    let!(:online_user) { create(:user, :online) }

    describe ".active" do
      it "returns only non-banned users" do
        expect(User.active).to include(active_user, online_user)
        expect(User.active).not_to include(banned_user)
      end
    end

    describe ".banned" do
      it "returns only banned users" do
        expect(User.banned).to include(banned_user)
        expect(User.banned).not_to include(active_user)
      end
    end

    describe ".online" do
      it "returns users seen within 5 minutes" do
        expect(User.online).to include(online_user)
        expect(User.online).not_to include(active_user)
      end
    end
  end

  describe "#banned?" do
    it "returns true when banned_at is set" do
      user = build(:user, :banned)
      expect(user.banned?).to be true
    end

    it "returns false when banned_at is nil" do
      user = build(:user)
      expect(user.banned?).to be false
    end
  end

  describe "#online?" do
    it "returns true when last_seen_at is within 5 minutes" do
      user = build(:user, last_seen_at: 1.minute.ago)
      expect(user.online?).to be true
    end

    it "returns false when last_seen_at is older than 5 minutes" do
      user = build(:user, last_seen_at: 10.minutes.ago)
      expect(user.online?).to be false
    end

    it "returns false when last_seen_at is nil" do
      user = build(:user, last_seen_at: nil)
      expect(user.online?).to be false
    end
  end

  describe "#follow" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "creates a follow relationship" do
      expect { user.follow(other_user) }.to change(Follow, :count).by(1)
    end

    it "does not allow self-follow" do
      result = user.follow(user)
      expect(result).to be_nil
    end
  end

  describe "#unfollow" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    before { user.follow(other_user) }

    it "removes the follow relationship" do
      expect { user.unfollow(other_user) }.to change(Follow, :count).by(-1)
    end
  end

  describe "#following?" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }

    it "returns true when following the user" do
      user.follow(other_user)
      expect(user.following?(other_user)).to be true
    end

    it "returns false when not following the user" do
      expect(user.following?(other_user)).to be false
    end
  end

  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456",
        info: OmniAuth::AuthHash::InfoHash.new(
          email: "oauth@example.com",
          name: "Jean Dupont"
        )
      )
    end

    context "when user with provider+uid exists" do
      let!(:existing_user) { create(:user, :google_oauth, uid: "123456") }

      it "returns the existing user" do
        user = User.from_omniauth(auth)
        expect(user).to eq(existing_user)
      end
    end

    context "when user with same email exists" do
      let!(:existing_user) { create(:user, email: "oauth@example.com") }

      it "links the provider and returns the user" do
        user = User.from_omniauth(auth)
        expect(user).to eq(existing_user)
        expect(user.provider).to eq("google_oauth2")
        expect(user.uid).to eq("123456")
      end
    end

    context "when no matching user exists" do
      it "creates a new user" do
        expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
      end

      it "sets the provider and uid" do
        user = User.from_omniauth(auth)
        expect(user.provider).to eq("google_oauth2")
        expect(user.uid).to eq("123456")
        expect(user.email).to eq("oauth@example.com")
      end

      it "generates a username from the name" do
        user = User.from_omniauth(auth)
        expect(user.username).to start_with("jean_dupont")
      end

      it "confirms the user automatically" do
        user = User.from_omniauth(auth)
        expect(user.confirmed_at).to be_present
      end
    end
  end

  describe ".generate_unique_username" do
    it "returns a parameterized username" do
      username = User.generate_unique_username("Jean Dupont")
      expect(username).to eq("jean_dupont")
    end

    it "appends a counter when username is taken" do
      create(:user, username: "jean_dupont")
      username = User.generate_unique_username("Jean Dupont")
      expect(username).to eq("jean_dupont_1")
    end

    it "falls back to 'user' for blank names" do
      username = User.generate_unique_username("")
      expect(username).to eq("user")
    end
  end

  describe "#password_required?" do
    it "returns false for OAuth users" do
      user = build(:user, :google_oauth)
      expect(user.password_required?).to be false
    end

    it "returns true for standard users" do
      user = build(:user, provider: nil)
      expect(user.password_required?).to be true
    end
  end
end
