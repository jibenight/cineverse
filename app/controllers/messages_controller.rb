class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params.merge(user: current_user))
    authorize @message

    spam_service = SpamDetectionService.new(current_user, @conversation)
    if spam_service.spam?
      spam_service.auto_mute!
      redirect_to @conversation, alert: "Votre message a été détecté comme spam."
      return
    end

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @conversation }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("message_form", partial: "messages/form", locals: { conversation: @conversation, message: @message }) }
        format.html { redirect_to @conversation, alert: @message.errors.full_messages.join(", ") }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :message_type, :shared_movie_id)
  end
end
