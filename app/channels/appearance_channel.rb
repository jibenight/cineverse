class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearance_channel"
    current_user.update_column(:last_seen_at, Time.current)
    broadcast_presence
  end

  def unsubscribed
    current_user.update_column(:last_seen_at, Time.current)
    broadcast_presence
  end

  def appear
    current_user.update_column(:last_seen_at, Time.current)
    broadcast_presence
  end

  def away
    broadcast_presence
  end

  private

  def broadcast_presence
    ActionCable.server.broadcast("appearance_channel", {
      type: "presence",
      user_id: current_user.id,
      online: current_user.online?
    })
  end
end
