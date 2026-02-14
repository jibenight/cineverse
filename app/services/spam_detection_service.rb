class SpamDetectionService
  DUPLICATE_MESSAGE_THRESHOLD = 3
  DUPLICATE_MESSAGE_WINDOW = 1.minute
  LINK_THRESHOLD = 5
  LINK_WINDOW = 1.minute

  def initialize(user, conversation)
    @user = user
    @conversation = conversation
  end

  def spam?
    duplicate_messages? || excessive_links?
  end

  def auto_mute!
    return unless spam?

    Mute.create!(
      user: @user,
      muted_by: User.find_by(role: :admin) || @user,
      scope: :global,
      duration: :one_hour,
      reason: "Auto-detected spam behavior",
      expires_at: 1.hour.from_now
    )
  end

  private

  def duplicate_messages?
    recent_messages = @user.messages
      .where(conversation: @conversation)
      .where("created_at > ?", DUPLICATE_MESSAGE_WINDOW.ago)

    recent_messages.group(:body).having("COUNT(*) >= ?", DUPLICATE_MESSAGE_THRESHOLD).exists?
  end

  def excessive_links?
    recent_messages = @user.messages
      .where(conversation: @conversation)
      .where("created_at > ?", LINK_WINDOW.ago)

    link_count = recent_messages.sum { |m| m.body.to_s.scan(%r{https?://}).count }
    link_count >= LINK_THRESHOLD
  end
end
