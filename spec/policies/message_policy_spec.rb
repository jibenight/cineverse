require 'rails_helper'

RSpec.describe MessagePolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:banned_user) { create(:user, :banned) }
  let(:conversation) { create(:conversation, created_by: user) }

  before do
    create(:conversation_participant, conversation: conversation, user: user)
    create(:conversation_participant, conversation: conversation, user: other_user)
  end

  subject { described_class }

  describe "#create?" do
    it "allows participants who are not banned or muted" do
      message = build(:message, conversation: conversation, user: user)
      expect(subject.new(user, message)).to be_create
    end

    it "denies banned users" do
      message = build(:message, conversation: conversation, user: banned_user)
      create(:conversation_participant, conversation: conversation, user: banned_user)
      expect(subject.new(banned_user, message)).not_to be_create
    end

    it "denies muted users" do
      create(:mute, user: user, muted_by: admin, scope: :global, duration: :one_hour, reason: "spam")
      message = build(:message, conversation: conversation, user: user)
      expect(subject.new(user, message)).not_to be_create
    end
  end

  describe "#destroy?" do
    it "allows the message owner" do
      message = create(:message, conversation: conversation, user: user)
      expect(subject.new(user, message)).to be_destroy
    end

    it "allows admin" do
      message = create(:message, conversation: conversation, user: user)
      expect(subject.new(admin, message)).to be_destroy
    end

    it "denies other users" do
      message = create(:message, conversation: conversation, user: user)
      expect(subject.new(other_user, message)).not_to be_destroy
    end
  end
end
