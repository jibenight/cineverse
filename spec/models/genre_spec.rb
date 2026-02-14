require 'rails_helper'

RSpec.describe Genre, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:movie_genres).dependent(:destroy) }
    it { is_expected.to have_many(:movies).through(:movie_genres) }
  end

  describe "validations" do
    subject { build(:genre) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:tmdb_id) }
  end
end
