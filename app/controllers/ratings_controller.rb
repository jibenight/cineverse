class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_movie

  def create
    @rating = @movie.ratings.build(rating_params.merge(user: current_user))
    authorize @rating

    if @rating.save
      BadgeCheckJob.perform_later(current_user.id)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @movie, notice: I18n.t("flash.rating.created") }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("rating_form", partial: "ratings/form", locals: { movie: @movie, rating: @rating }) }
        format.html { redirect_to @movie, alert: @rating.errors.full_messages.join(", ") }
      end
    end
  end

  def update
    @rating = @movie.ratings.find(params[:id])
    authorize @rating

    if @rating.update(rating_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @movie, notice: I18n.t("flash.rating.updated") }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("rating_form", partial: "ratings/form", locals: { movie: @movie, rating: @rating }) }
        format.html { redirect_to @movie, alert: @rating.errors.full_messages.join(", ") }
      end
    end
  end

  def destroy
    @rating = @movie.ratings.find(params[:id])
    authorize @rating
    @rating.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @movie, notice: I18n.t("flash.rating.destroyed") }
    end
  end

  def like
    @rating = @movie.ratings.find(params[:id])
    authorize @rating, :like?
    current_user.rating_likes.find_or_create_by(rating: @rating)

    Notification.create(user: @rating.user, notifiable: @rating, action: :new_like) unless @rating.user == current_user

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("rating_#{@rating.id}_likes", partial: "ratings/likes", locals: { rating: @rating.reload }) }
      format.html { redirect_back(fallback_location: @movie) }
    end
  end

  def unlike
    @rating = @movie.ratings.find(params[:id])
    authorize @rating, :like?
    current_user.rating_likes.find_by(rating: @rating)&.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("rating_#{@rating.id}_likes", partial: "ratings/likes", locals: { rating: @rating.reload }) }
      format.html { redirect_back(fallback_location: @movie) }
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def rating_params
    params.require(:rating).permit(:score, :review_text, :spoiler)
  end
end
