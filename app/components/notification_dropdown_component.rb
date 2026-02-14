class NotificationDropdownComponent < ViewComponent::Base
  def initialize(notifications:, unread_count:)
    @notifications = notifications
    @unread_count = unread_count
  end

  def render?
    true
  end
end
