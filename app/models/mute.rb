class Mute < ApplicationRecord
  belongs_to :user
  belongs_to :muted_by, class_name: "User"
  belongs_to :conversation, optional: true

  enum :scope, { global: 0, conversation: 1 }, prefix: true
  enum :duration, { one_hour: 0, twenty_four_hours: 1, seven_days: 2, permanent: 3 }

  validates :reason, presence: true

  scope :active, -> { where("expires_at IS NULL OR expires_at > ?", Time.current) }

  before_create :set_expires_at

  def active?
    expires_at.nil? || expires_at > Time.current
  end

  private

  def set_expires_at
    self.expires_at = if one_hour?
      1.hour.from_now
    elsif twenty_four_hours?
      24.hours.from_now
    elsif seven_days?
      7.days.from_now
    elsif permanent?
      nil
    end
  end
end
