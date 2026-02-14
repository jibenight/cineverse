require 'rails_helper'

RSpec.describe CastMember, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:movie_cast_members).dependent(:destroy) }
    it { is_expected.to have_many(:movies).through(:movie_cast_members) }
  end

  describe "validations" do
    subject { build(:cast_member) }

    it { is_expected.to validate_presence_of(:tmdb_id) }
    it { is_expected.to validate_uniqueness_of(:tmdb_id) }
    it { is_expected.to validate_presence_of(:name) }
  end
end
