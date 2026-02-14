class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend

  allow_browser versions: :modern

  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :track_last_seen

  after_action :verify_authorized, unless: -> { devise_controller? || action_name == "index" }
  after_action :verify_policy_scoped, if: -> { !devise_controller? && action_name == "index" }

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_user_unread_notifications_count

  private

  def set_locale
    I18n.locale = :fr
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :bio, :city, :theme_preference])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :bio, :city, :theme_preference, :avatar, :notifications_enabled])
  end

  def track_last_seen
    if current_user && (current_user.last_seen_at.nil? || current_user.last_seen_at < 5.minutes.ago)
      current_user.update_column(:last_seen_at, Time.current)
    end
  end

  def user_not_authorized
    flash[:alert] = I18n.t("pundit.not_authorized")
    redirect_back(fallback_location: root_path)
  end

  def current_user_unread_notifications_count
    return 0 unless current_user
    @current_user_unread_notifications_count ||= current_user.notifications.unread.count
  end
end
