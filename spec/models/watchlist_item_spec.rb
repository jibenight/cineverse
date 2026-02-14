require 'rails_helper'

RSpec.describe WatchlistItem, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:movie) }
  end

  describe "validations" do
    subject { build(:watchlist_item) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:movie_id) }
  end

  describe "callbacks" do
    it "auto-sets position on create" do
      user = create(:user)
      item1 = create(:watchlist_item, user: user)
      item2 = create(:watchlist_item, user: user)
      expect(item1.position).to eq(1)
      expect(item2.position).to eq(2)
    end
  end

  describe "scopes" do
    it ".ordered returns items by position asc" do
      user = create(:user)
      item2 = create(:watchlist_item, user: user, position: 2)
      item1 = create(:watchlist_item, user: user, position: 1)
      expect(WatchlistItem.ordered.first).to eq(item1)
    end
  end
end
