require 'rails_helper'

RSpec.describe "Ratings", type: :request do
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }

  describe "POST /movies/:movie_id/ratings" do
    before { sign_in user }

    it "creates a rating" do
      expect {
        post movie_ratings_path(movie), params: { rating: { score: 4.0 } }
      }.to change(Rating, :count).by(1)
    end

    it "creates a rating with review" do
      post movie_ratings_path(movie), params: { rating: { score: 4.5, review_text: "Super !" } }
      expect(Rating.last.review_text).to eq("Super !")
    end
  end

  describe "PATCH /movies/:movie_id/ratings/:id" do
    let!(:rating) { create(:rating, user: user, movie: movie, score: 3.0) }

    before { sign_in user }

    it "updates the rating" do
      patch movie_rating_path(movie, rating), params: { rating: { score: 4.5 } }
      expect(rating.reload.score).to eq(4.5)
    end
  end

  describe "DELETE /movies/:movie_id/ratings/:id" do
    let!(:rating) { create(:rating, user: user, movie: movie) }

    before { sign_in user }

    it "deletes the rating" do
      expect {
        delete movie_rating_path(movie, rating)
      }.to change(Rating, :count).by(-1)
    end
  end

  describe "POST /movies/:movie_id/ratings/:id/like" do
    let(:other_user) { create(:user) }
    let!(:rating) { create(:rating, user: other_user, movie: movie) }

    before { sign_in user }

    it "likes the rating" do
      expect {
        post like_movie_rating_path(movie, rating), headers: { "Accept" => "text/html" }
      }.to change(RatingLike, :count).by(1)
    end
  end

  describe "DELETE /movies/:movie_id/ratings/:id/unlike" do
    let(:other_user) { create(:user) }
    let!(:rating) { create(:rating, user: other_user, movie: movie) }
    let!(:like) { create(:rating_like, user: user, rating: rating) }

    before { sign_in user }

    it "unlikes the rating" do
      expect {
        delete unlike_movie_rating_path(movie, rating), headers: { "Accept" => "text/html" }
      }.to change(RatingLike, :count).by(-1)
    end
  end
end
