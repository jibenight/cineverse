class UsersController < ApplicationController
  skip_after_action :verify_authorized, raise: false
  skip_after_action :verify_policy_scoped, raise: false
  after_action :verify_authorized, only: [:follow, :unfollow]

  def show
    @user = User.find_by!(username: params[:username])
    @ratings = @user.ratings.includes(:movie).recent.limit(10)
    @badges = @user.badges
    @cinema_passes = @user.cinema_passes.visible
    @discounts = @user.user_discounts.shareable
    @stats = {
      movies_rated: @user.ratings.count,
      average_rating: @user.ratings.average(:score)&.round(1) || 0,
      followers_count: @user.followers.count,
      following_count: @user.following.count
    }
  end

  def follow
    @user = User.find_by!(username: params[:username])
    authorize @user, :follow?
    current_user.follow(@user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(@user.username), notice: I18n.t("flash.follow.created", user: @user.username) }
    end
  end

  def unfollow
    @user = User.find_by!(username: params[:username])
    authorize @user, :follow?
    current_user.unfollow(@user)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to user_path(@user.username), notice: I18n.t("flash.follow.destroyed", user: @user.username) }
    end
  end
end
