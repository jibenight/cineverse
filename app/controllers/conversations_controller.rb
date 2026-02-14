class ConversationsController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_policy_scoped, except: [:index]

  def index
    @conversations = policy_scope(Conversation.for_user(current_user).ordered.includes(:participants, :messages))
  end

  def show
    @conversation = Conversation.find(params[:id])
    authorize @conversation
    @conversation.conversation_participants.find_by(user: current_user)&.mark_as_read!
    @pagy, @messages = pagy(@conversation.messages.includes(:user, :shared_movie).chronological, limit: 50)
    @message = Message.new
  end

  def create
    @conversation = Conversation.new(conversation_params.merge(created_by: current_user))
    authorize @conversation

    if @conversation.save
      @conversation.conversation_participants.create!(user: current_user, role: :admin)
      if params[:recipient_id].present?
        @conversation.conversation_participants.create!(user_id: params[:recipient_id], role: :member)
      end
      redirect_to @conversation
    else
      redirect_back fallback_location: conversations_path, alert: @conversation.errors.full_messages.join(", ")
    end
  end

  def destroy
    @conversation = Conversation.find(params[:id])
    authorize @conversation
    @conversation.destroy
    redirect_to conversations_path
  end

  def add_participant
    @conversation = Conversation.find(params[:id])
    authorize @conversation, :update?
    @conversation.conversation_participants.create!(user_id: params[:user_id], role: :member)
    redirect_to @conversation
  end

  def remove_participant
    @conversation = Conversation.find(params[:id])
    authorize @conversation, :update?
    @conversation.conversation_participants.find_by(user_id: params[:user_id])&.destroy
    redirect_to @conversation
  end

  def mark_as_read
    @conversation = Conversation.find(params[:id])
    authorize @conversation, :show?
    @conversation.conversation_participants.find_by(user: current_user)&.mark_as_read!
    head :ok
  end

  def leave
    @conversation = Conversation.find(params[:id])
    authorize @conversation, :show?
    @conversation.conversation_participants.find_by(user: current_user)&.destroy
    redirect_to conversations_path
  end

  private

  def conversation_params
    params.require(:conversation).permit(:title, :is_group)
  end
end
