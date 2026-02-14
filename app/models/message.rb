class Message < ApplicationRecord
  belongs_to :conversation, touch: true
  belongs_to :user
  belongs_to :shared_movie, class_name: "Movie", optional: true
  has_many :reports, as: :reportable, dependent: :destroy

  enum :message_type, { text: 0, movie_share: 1, discount_share: 2, cinema_invite: 3 }

  validates :body, presence: true, if: -> { text? || discount_share? || cinema_invite? }
  validates :shared_movie_id, presence: true, if: -> { movie_share? }

  scope :recent, -> { order(created_at: :desc) }
  scope :chronological, -> { order(created_at: :asc) }

  after_create_commit :broadcast_message

  private

  def broadcast_message
    ConversationChannel.broadcast_to(conversation, {
      type: "new_message",
      message_id: id,
      html: ApplicationController.render(
        partial: "messages/message",
        locals: { message: self }
      )
    })
  rescue StandardError => e
    Rails.logger.error("Message broadcast failed for message ##{id}: #{e.message}")
  end
end
