class MovieCastMember < ApplicationRecord
  belongs_to :movie
  belongs_to :cast_member

  validates :cast_member_id, uniqueness: { scope: :movie_id }

  scope :ordered, -> { order(:order) }
end
