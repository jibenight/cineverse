require 'rails_helper'

RSpec.describe Conversation, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:created_by).class_name("User") }
    it { is_expected.to have_many(:conversation_participants).dependent(:destroy) }
    it { is_expected.to have_many(:participants).through(:conversation_participants) }
    it { is_expected.to have_many(:messages).dependent(:destroy) }
  end

  describe "#last_message" do
    it "returns the most recent message" do
      conversation = create(:conversation)
      old_msg = create(:message, conversation: conversation, created_at: 1.hour.ago)
      new_msg = create(:message, conversation: conversation, created_at: 1.minute.ago)
      expect(conversation.last_message).to eq(new_msg)
    end
  end

  describe "#unread_count_for" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:conversation) { create(:conversation, created_by: user) }

    before do
      create(:conversation_participant, conversation: conversation, user: user, last_read_at: 1.hour.ago)
      create(:conversation_participant, conversation: conversation, user: other_user)
    end

    it "counts messages after last_read_at from other users" do
      create(:message, conversation: conversation, user: other_user, created_at: 30.minutes.ago)
      create(:message, conversation: conversation, user: other_user, created_at: 10.minutes.ago)
      expect(conversation.unread_count_for(user)).to eq(2)
    end

    it "does not count own messages" do
      create(:message, conversation: conversation, user: user, created_at: 30.minutes.ago)
      expect(conversation.unread_count_for(user)).to eq(0)
    end
  end

  describe "#other_participant" do
    it "returns the other user in a DM" do
      user = create(:user)
      other = create(:user)
      conversation = create(:conversation, created_by: user, is_group: false)
      create(:conversation_participant, conversation: conversation, user: user)
      create(:conversation_participant, conversation: conversation, user: other)
      expect(conversation.other_participant(user)).to eq(other)
    end

    it "returns nil for group conversations" do
      conversation = create(:conversation, :group)
      expect(conversation.other_participant(create(:user))).to be_nil
    end
  end
end
