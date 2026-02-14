class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def unsubscribed
    stop_all_streams
  end

  def self.notify(user, notification)
    broadcast_to(user, {
      type: "notification",
      id: notification.id,
      action: notification.action,
      message: notification_message(notification),
      created_at: notification.created_at.iso8601,
      unread_count: user.notifications.unread.count
    })
  end

  private

  def self.notification_message(notification)
    case notification.action
    when "new_follower"
      "#{notification.notifiable.follower.username} vous suit"
    when "new_like"
      "#{notification.notifiable.user.username} a aimé votre critique"
    when "new_message"
      "Nouveau message"
    when "release_alert"
      "#{notification.notifiable.title} sort aujourd'hui !"
    when "badge_earned"
      "Badge débloqué : #{notification.notifiable.badge.name}"
    else
      "Nouvelle notification"
    end
  rescue StandardError
    "Nouvelle notification"
  end
end
