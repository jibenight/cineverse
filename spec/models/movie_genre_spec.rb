require 'rails_helper'

RSpec.describe MovieGenre, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:movie) }
    it { is_expected.to belong_to(:genre) }
  end

  describe "validations" do
    subject { build(:movie_genre, movie: create(:movie), genre: create(:genre)) }

    it { is_expected.to validate_uniqueness_of(:movie_id).scoped_to(:genre_id) }
  end
end
