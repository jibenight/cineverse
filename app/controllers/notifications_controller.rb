class NotificationsController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    @pagy, @notifications = pagy(current_user.notifications.recent, limit: 30)
  end

  def mark_all_read
    current_user.notifications.unread.update_all(read: true)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("notifications_badge", html: "") }
      format.html { redirect_to notifications_path }
    end
  end
end
