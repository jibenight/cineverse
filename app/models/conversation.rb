class Conversation < ApplicationRecord
  belongs_to :created_by, class_name: "User"
  has_many :conversation_participants, dependent: :destroy
  has_many :participants, through: :conversation_participants, source: :user
  has_many :messages, dependent: :destroy

  scope :for_user, ->(user) { joins(:conversation_participants).where(conversation_participants: { user_id: user.id }) }
  scope :ordered, -> { order(updated_at: :desc) }

  def last_message
    messages.order(created_at: :desc).first
  end

  def unread_count_for(user)
    participant = conversation_participants.find_by(user: user)
    return 0 unless participant&.last_read_at
    messages.where("created_at > ?", participant.last_read_at).where.not(user: user).count
  end

  def other_participant(user)
    participants.where.not(id: user.id).first unless is_group?
  end
end
