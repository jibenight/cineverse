module Users
  class RatingsController < ApplicationController
    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    def index
      @user = User.find_by!(username: params[:user_username])
      @pagy, @ratings = pagy(@user.ratings.includes(:movie).recent)
    end
  end
end
