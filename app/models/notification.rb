class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  enum :action, {
    new_message: 0,
    new_follower: 1,
    new_like: 2,
    release_alert: 3,
    badge_earned: 4
  }

  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }

  def mark_as_read!
    update(read: true)
  end
end
