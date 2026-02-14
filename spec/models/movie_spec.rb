require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:movie_genres).dependent(:destroy) }
    it { is_expected.to have_many(:genres).through(:movie_genres) }
    it { is_expected.to have_many(:movie_cast_members).dependent(:destroy) }
    it { is_expected.to have_many(:cast_members).through(:movie_cast_members) }
    it { is_expected.to have_many(:ratings).dependent(:destroy) }
    it { is_expected.to have_many(:watchlist_items).dependent(:destroy) }
    it { is_expected.to have_many(:release_alerts).dependent(:destroy) }
    it { is_expected.to have_many(:affiliate_clicks).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:movie) }

    it { is_expected.to validate_presence_of(:tmdb_id) }
    it { is_expected.to validate_uniqueness_of(:tmdb_id) }
    it { is_expected.to validate_presence_of(:title) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(now_playing: 0, upcoming: 1, released: 2) }
  end

  describe "scopes" do
    let!(:now_playing_movie) { create(:movie, status: :now_playing, popularity: 80) }
    let!(:upcoming_movie) { create(:movie, :upcoming) }
    let!(:released_movie) { create(:movie, :released) }

    it ".popular orders by popularity desc" do
      expect(Movie.popular.first).to eq(now_playing_movie)
    end

    it ".top_rated orders by vote_average desc" do
      high_rated = create(:movie, vote_average: 5.0)
      expect(Movie.top_rated.first).to eq(high_rated)
    end

    it ".recent orders by release_date desc" do
      expect(Movie.recent.first.release_date).to be >= Movie.recent.last.release_date
    end
  end

  describe "#community_rating" do
    let(:movie) { create(:movie) }

    it "returns average score of all ratings" do
      create(:rating, movie: movie, score: 4.0)
      create(:rating, movie: movie, score: 3.0)
      expect(movie.community_rating).to eq(3.5)
    end

    it "returns nil when no ratings" do
      expect(movie.community_rating).to be_nil
    end
  end

end
