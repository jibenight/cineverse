require 'rails_helper'

RSpec.describe "Conversations", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before { sign_in user }

  describe "GET /conversations" do
    it "returns success" do
      get conversations_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /conversations" do
    it "creates a new DM conversation" do
      expect {
        post conversations_path, params: { conversation: { recipient_id: other_user.id } }
      }.to change(Conversation, :count).by(1)
    end
  end

  describe "GET /conversations/:id" do
    let(:conversation) { create(:conversation, created_by: user) }

    before do
      create(:conversation_participant, conversation: conversation, user: user)
      create(:conversation_participant, conversation: conversation, user: other_user)
      create(:message, conversation: conversation, user: other_user, body: "Hello!")
    end

    it "returns success" do
      get conversation_path(conversation)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /conversations/:id/mark_as_read" do
    let(:conversation) { create(:conversation, created_by: user) }

    before do
      create(:conversation_participant, conversation: conversation, user: user, last_read_at: 1.day.ago)
    end

    it "updates last_read_at" do
      patch mark_as_read_conversation_path(conversation)
      participant = ConversationParticipant.find_by(conversation: conversation, user: user)
      expect(participant.last_read_at).to be > 1.minute.ago
    end
  end
end
