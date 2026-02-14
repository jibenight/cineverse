require 'rails_helper'

RSpec.describe CinemaPassPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:cinema_pass) { create(:cinema_pass, user: user) }

  subject { described_class }

  describe "#create?" do
    it "allows logged-in users" do
      expect(subject.new(user, CinemaPass.new)).to be_create
    end

    it "denies guests" do
      expect(subject.new(nil, CinemaPass.new)).not_to be_create
    end
  end

  describe "#update?" do
    it "allows the owner" do
      expect(subject.new(user, cinema_pass)).to be_update
    end

    it "denies other users" do
      expect(subject.new(other_user, cinema_pass)).not_to be_update
    end
  end

  describe "#destroy?" do
    it "allows the owner" do
      expect(subject.new(user, cinema_pass)).to be_destroy
    end

    it "allows admin" do
      expect(subject.new(admin, cinema_pass)).to be_destroy
    end

    it "denies other users" do
      expect(subject.new(other_user, cinema_pass)).not_to be_destroy
    end
  end
end
