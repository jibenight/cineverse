require 'rails_helper'

RSpec.describe Rating, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:movie) }
    it { is_expected.to have_many(:rating_likes).dependent(:destroy) }
    it { is_expected.to have_many(:likers).through(:rating_likes) }
    it { is_expected.to have_many(:reports).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:rating) }

    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_numericality_of(:score).is_greater_than_or_equal_to(0.5).is_less_than_or_equal_to(5.0) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:movie_id) }

    it "accepts valid scores in 0.5 steps" do
      [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0].each do |score|
        rating = build(:rating, score: score)
        expect(rating).to be_valid
      end
    end

    it "rejects scores not in 0.5 steps" do
      rating = build(:rating, score: 1.3)
      expect(rating).not_to be_valid
      expect(rating.errors[:score]).to include("must be in steps of 0.5")
    end
  end

  describe "scopes" do
    let!(:rating_with_review) { create(:rating, :with_review) }
    let!(:rating_without_review) { create(:rating) }
    let!(:liked_rating) { create(:rating, likes_count: 10) }

    it ".with_review returns only ratings with text" do
      expect(Rating.with_review).to include(rating_with_review)
      expect(Rating.with_review).not_to include(rating_without_review)
    end

    it ".most_liked orders by likes_count desc" do
      expect(Rating.most_liked.first).to eq(liked_rating)
    end
  end

  describe "callbacks" do
    it "updates movie ratings_count after create" do
      movie = create(:movie, ratings_count: 0)
      create(:rating, movie: movie)
      expect(movie.reload.ratings_count).to eq(1)
    end

    it "updates movie vote_average after create" do
      movie = create(:movie, vote_average: 0)
      create(:rating, movie: movie, score: 4.5)
      expect(movie.reload.vote_average).to eq(4.5)
    end

    it "updates movie ratings_count after destroy" do
      movie = create(:movie)
      rating = create(:rating, movie: movie)
      rating.destroy
      expect(movie.reload.ratings_count).to eq(0)
    end
  end
end
