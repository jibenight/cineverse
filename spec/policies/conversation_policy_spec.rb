require 'rails_helper'

RSpec.describe ConversationPolicy do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:banned_user) { create(:user, :banned) }
  let(:conversation) { create(:conversation, created_by: user) }

  before do
    create(:conversation_participant, conversation: conversation, user: user, role: :admin)
  end

  subject { described_class }

  describe "#show?" do
    it "allows participants" do
      expect(subject.new(user, conversation)).to be_show
    end

    it "denies non-participants" do
      expect(subject.new(other_user, conversation)).not_to be_show
    end

    it "allows admins even if not participant" do
      expect(subject.new(admin, conversation)).to be_show
    end
  end

  describe "#create?" do
    it "allows non-banned users" do
      expect(subject.new(user, Conversation.new)).to be_create
    end

    it "denies banned users" do
      expect(subject.new(banned_user, Conversation.new)).not_to be_create
    end
  end

  describe "#destroy?" do
    it "allows conversation admin" do
      expect(subject.new(user, conversation)).to be_destroy
    end

    it "allows global admin" do
      expect(subject.new(admin, conversation)).to be_destroy
    end

    it "denies regular members" do
      create(:conversation_participant, conversation: conversation, user: other_user, role: :member)
      expect(subject.new(other_user, conversation)).not_to be_destroy
    end
  end
end
