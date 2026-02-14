require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:conversation) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:shared_movie).class_name("Movie").optional }
    it { is_expected.to have_many(:reports).dependent(:destroy) }
  end

  describe "validations" do
    it "requires body for text messages" do
      message = build(:message, message_type: :text, body: nil)
      expect(message).not_to be_valid
    end

    it "requires shared_movie_id for movie_share messages" do
      message = build(:message, message_type: :movie_share, shared_movie_id: nil)
      expect(message).not_to be_valid
    end

    it "allows blank body for movie_share messages" do
      movie = create(:movie)
      message = build(:message, message_type: :movie_share, body: nil, shared_movie: movie)
      expect(message).to be_valid
    end
  end

  describe "enums" do
    it {
      is_expected.to define_enum_for(:message_type).with_values(
        text: 0, movie_share: 1, discount_share: 2, cinema_invite: 3
      )
    }
  end

  describe "scopes" do
    it ".chronological orders by created_at asc" do
      conv = create(:conversation)
      old = create(:message, conversation: conv, created_at: 1.hour.ago)
      new_msg = create(:message, conversation: conv, created_at: 1.minute.ago)
      expect(Message.chronological.first).to eq(old)
    end
  end
end
