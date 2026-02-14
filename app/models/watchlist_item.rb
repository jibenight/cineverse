class WatchlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :user_id, uniqueness: { scope: :movie_id }

  scope :ordered, -> { order(position: :asc) }

  before_create :set_position

  private

  def set_position
    self.position ||= (user.watchlist_items.maximum(:position) || 0) + 1
  end
end
