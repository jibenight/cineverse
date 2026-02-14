class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id }
  validate :cannot_follow_self

  after_create :create_notification

  private

  def cannot_follow_self
    errors.add(:follower_id, "cannot follow yourself") if follower_id == followed_id
  end

  def create_notification
    Notification.create(
      user: followed,
      notifiable: self,
      action: :new_follower
    )
  end
end
