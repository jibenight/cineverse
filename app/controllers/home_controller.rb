class HomeController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    @now_playing = Movie.now_playing.order(popularity: :desc).limit(12)
    @upcoming = Movie.upcoming.limit(6)
    @trending = Movie.joins(:ratings)
      .where(ratings: { created_at: 1.week.ago.. })
      .group("movies.id")
      .order("COUNT(ratings.id) DESC")
      .limit(6)
    @latest_reviews = Rating.includes(:user, :movie).with_review.not_reported.recent.limit(10)
  end
end
