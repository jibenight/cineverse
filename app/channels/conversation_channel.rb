class ConversationChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:id])
    if conversation.participants.include?(current_user)
      stream_for conversation
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(data)
    conversation = Conversation.find(params[:id])

    message = conversation.messages.create!(
      user: current_user,
      body: data["body"],
      message_type: data["message_type"] || "text",
      shared_movie_id: data["shared_movie_id"]
    )

    ConversationChannel.broadcast_to(conversation, {
      type: "new_message",
      message: {
        id: message.id,
        body: message.body,
        message_type: message.message_type,
        user_id: current_user.id,
        username: current_user.username,
        created_at: message.created_at.iso8601
      }
    })
  end
end
