class WatchlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  validates :user_id, uniqueness: { scope: :movie_id }

  scope :ordered, -> { order(position: :asc) }

  before_create :set_position

  private

  def set_position
    self.position ||= begin
      lock_key = "watchlist_position_#{user_id}".hash.abs
      self.class.connection.execute(
        self.class.sanitize_sql_array(["SELECT pg_advisory_xact_lock(?)", lock_key])
      )
      max_pos = self.class.where(user_id: user_id).maximum(:position) || 0
      max_pos + 1
    end
  end
end
