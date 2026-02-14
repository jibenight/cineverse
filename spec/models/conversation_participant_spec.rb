require 'rails_helper'

RSpec.describe ConversationParticipant, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:conversation) }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    subject { build(:conversation_participant) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:conversation_id) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:role).with_values(member: 0, admin: 1) }
  end

  describe "#mark_as_read!" do
    it "updates last_read_at" do
      participant = create(:conversation_participant, last_read_at: 1.day.ago)
      participant.mark_as_read!
      expect(participant.reload.last_read_at).to be > 1.minute.ago
    end
  end
end
