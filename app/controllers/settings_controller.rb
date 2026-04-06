class SettingsController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def show
    @user = current_user
    @cinema_passes = current_user.cinema_passes
    @discounts = current_user.user_discounts
  end

  def update
    @user = current_user
    if @user.update(user_settings_params)
      respond_to do |format|
        format.html { redirect_to settings_path, notice: I18n.t("general.save") }
        format.json { render json: { status: "ok" } }
      end
    else
      respond_to do |format|
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_settings_params
    params.require(:user).permit(:username, :bio, :city, :theme_preference, :avatar, :notifications_enabled)
  end
end
