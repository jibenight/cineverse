class MoviesController < ApplicationController
  before_action :authenticate_user!, only: [:toggle_watchlist, :toggle_release_alert]
  skip_after_action :verify_authorized, only: [:index, :show, :now_playing, :upcoming, :trending, :calendar, :import_tmdb]
  skip_after_action :verify_policy_scoped, except: [:index]

  def index
    @pagy, @movies = pagy(policy_scope(Movie).order(popularity: :desc))
  end

  def show
    @movie = Movie.includes(:genres, :cast_members, :ratings).find(params[:id])
    @pagy, @ratings = pagy(@movie.ratings.includes(:user).with_review.not_reported.recent, limit: 10)
    @user_rating = current_user&.ratings&.find_by(movie: @movie)
    @in_watchlist = current_user&.watchlist_items&.exists?(movie: @movie)
    @release_alert = current_user&.release_alerts&.find_by(movie: @movie)
    @affiliate_links = AffiliateLinksService.new.links_for(@movie, user: current_user) if @movie.now_playing?
  end

  def now_playing
    @pagy, @movies = pagy(Movie.now_playing.order(popularity: :desc))
  end

  def upcoming
    @pagy, @movies = pagy(Movie.upcoming.order(release_date: :asc))
  end

  def trending
    @movies = Movie.joins(:ratings)
      .where(ratings: { created_at: 1.week.ago.. })
      .group("movies.id")
      .order("COUNT(ratings.id) DESC")
      .limit(20)

    @movies = Movie.order(popularity: :desc).limit(20) if @movies.empty?
  end

  def calendar
    @month = params[:month] ? Date.parse(params[:month]) : Date.current.beginning_of_month
    @movies = Movie.where(release_date: @month..@month.end_of_month).order(release_date: :asc)
  end

  def import_tmdb
    movie = TmdbSyncService.new.sync_movie_details(params[:tmdb_id])
    if movie
      redirect_to movie, notice: t("pages.movies.imported_successfully")
    else
      redirect_to search_path, alert: t("pages.movies.import_failed")
    end
  end

  def toggle_watchlist
    @movie = Movie.find(params[:id])
    authorize @movie, :show?

    item = current_user.watchlist_items.find_by(movie: @movie)
    if item
      item.destroy
      @in_watchlist = false
    else
      current_user.watchlist_items.create!(movie: @movie)
      @in_watchlist = true
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: @movie) }
    end
  end

  def toggle_release_alert
    @movie = Movie.find(params[:id])
    authorize @movie, :show?

    alert = current_user.release_alerts.find_by(movie: @movie)
    if alert
      alert.destroy
      @has_alert = false
    else
      current_user.release_alerts.create!(movie: @movie)
      @has_alert = true
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back(fallback_location: @movie) }
    end
  end
end
