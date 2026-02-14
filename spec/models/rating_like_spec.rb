require 'rails_helper'

RSpec.describe RatingLike, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:rating) }
  end

  describe "validations" do
    subject { build(:rating_like) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:rating_id) }
  end

  describe "counter_cache" do
    it "increments likes_count on rating" do
      rating = create(:rating, likes_count: 0)
      create(:rating_like, rating: rating)
      expect(rating.reload.likes_count).to eq(1)
    end

    it "decrements likes_count on rating when destroyed" do
      rating = create(:rating, likes_count: 0)
      like = create(:rating_like, rating: rating)
      like.destroy
      expect(rating.reload.likes_count).to eq(0)
    end
  end
end
