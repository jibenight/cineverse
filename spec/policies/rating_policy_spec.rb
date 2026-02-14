require 'rails_helper'

RSpec.describe RatingPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:banned_user) { create(:user, :banned) }
  let(:admin) { create(:user, :admin) }
  let(:rating) { create(:rating, user: user) }

  subject { described_class }

  describe "#create?" do
    it "allows logged-in, non-banned users" do
      expect(subject.new(user, Rating.new)).to be_create
    end

    it "denies banned users" do
      expect(subject.new(banned_user, Rating.new)).not_to be_create
    end

    it "denies guests" do
      expect(subject.new(nil, Rating.new)).not_to be_create
    end
  end

  describe "#update?" do
    it "allows the owner" do
      expect(subject.new(user, rating)).to be_update
    end

    it "denies other users" do
      expect(subject.new(other_user, rating)).not_to be_update
    end

    it "denies banned owner" do
      rating = create(:rating, user: banned_user)
      expect(subject.new(banned_user, rating)).not_to be_update
    end
  end

  describe "#destroy?" do
    it "allows the owner" do
      expect(subject.new(user, rating)).to be_destroy
    end

    it "allows admins" do
      expect(subject.new(admin, rating)).to be_destroy
    end

    it "denies other users" do
      expect(subject.new(other_user, rating)).not_to be_destroy
    end
  end

  describe "#like?" do
    it "allows other users to like" do
      expect(subject.new(other_user, rating)).to be_like
    end

    it "denies owner from liking own rating" do
      expect(subject.new(user, rating)).not_to be_like
    end

    it "denies banned users" do
      expect(subject.new(banned_user, rating)).not_to be_like
    end
  end
end
