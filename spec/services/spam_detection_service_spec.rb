require 'rails_helper'

RSpec.describe SpamDetectionService do
  let(:user) { create(:user) }
  let(:conversation) { create(:conversation, created_by: user) }

  before do
    create(:conversation_participant, conversation: conversation, user: user)
  end

  describe "#spam?" do
    context "duplicate messages" do
      it "returns true when same message sent 3+ times in 1 minute" do
        3.times do
          create(:message, user: user, conversation: conversation, body: "spam message", created_at: 30.seconds.ago)
        end
        service = described_class.new(user, conversation)
        expect(service.spam?).to be true
      end

      it "returns false for different messages" do
        3.times do |i|
          create(:message, user: user, conversation: conversation, body: "message #{i}", created_at: 30.seconds.ago)
        end
        service = described_class.new(user, conversation)
        expect(service.spam?).to be false
      end

      it "returns false when messages are old" do
        3.times do
          create(:message, user: user, conversation: conversation, body: "spam", created_at: 2.minutes.ago)
        end
        service = described_class.new(user, conversation)
        expect(service.spam?).to be false
      end
    end

    context "excessive links" do
      it "returns true when 5+ links in 1 minute" do
        5.times do
          create(:message, user: user, conversation: conversation,
            body: "Check out https://example.com/#{SecureRandom.hex(4)}",
            created_at: 30.seconds.ago)
        end
        service = described_class.new(user, conversation)
        expect(service.spam?).to be true
      end

      it "returns false for fewer than 5 links" do
        2.times do
          create(:message, user: user, conversation: conversation,
            body: "See https://example.com",
            created_at: 30.seconds.ago)
        end
        service = described_class.new(user, conversation)
        expect(service.spam?).to be false
      end
    end
  end

  describe "#auto_mute!" do
    it "creates a mute when spam is detected" do
      admin = create(:user, :admin)
      3.times do
        create(:message, user: user, conversation: conversation, body: "spam!", created_at: 30.seconds.ago)
      end
      service = described_class.new(user, conversation)
      expect { service.auto_mute! }.to change(Mute, :count).by(1)
    end

    it "does not create mute when no spam" do
      service = described_class.new(user, conversation)
      expect { service.auto_mute! }.not_to change(Mute, :count)
    end
  end
end
