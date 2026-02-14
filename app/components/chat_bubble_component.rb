class ChatBubbleComponent < ViewComponent::Base
  def initialize(message:, current_user:)
    @message = message
    @current_user = current_user
  end

  def own_message?
    @message.user_id == @current_user.id
  end

  def avatar_url
    if @message.user.avatar.attached?
      url_for(@message.user.avatar)
    else
      "default_avatar.png"
    end
  end
end
