require 'rails_helper'

RSpec.describe UserPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:banned_user) { create(:user, :banned) }

  subject { described_class }

  describe "#show?" do
    it "allows anyone to view profiles" do
      expect(subject.new(nil, user)).to be_show
    end
  end

  describe "#update?" do
    it "allows user to edit own profile" do
      expect(subject.new(user, user)).to be_update
    end

    it "denies editing other profiles" do
      expect(subject.new(user, other_user)).not_to be_update
    end

    it "allows admin to edit any profile" do
      expect(subject.new(admin, user)).to be_update
    end
  end

  describe "#follow?" do
    it "allows logged-in non-banned users to follow others" do
      expect(subject.new(user, other_user)).to be_follow
    end

    it "denies self-follow" do
      expect(subject.new(user, user)).not_to be_follow
    end

    it "denies banned users" do
      expect(subject.new(banned_user, other_user)).not_to be_follow
    end
  end

  describe "#ban?" do
    it "allows admin to ban non-admin users" do
      expect(subject.new(admin, user)).to be_ban
    end

    it "denies admin banning other admins" do
      other_admin = create(:user, :admin)
      expect(subject.new(admin, other_admin)).not_to be_ban
    end

    it "denies non-admin users" do
      expect(subject.new(user, other_user)).not_to be_ban
    end
  end
end
