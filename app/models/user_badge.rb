class UserBadge < ApplicationRecord
  belongs_to :user
  belongs_to :badge

  validates :user_id, uniqueness: { scope: :badge_id }

  after_create :create_notification

  private

  def create_notification
    Notification.create(
      user: user,
      notifiable: self,
      action: :badge_earned
    )
  end
end
