class MovieCastMember < ApplicationRecord
  belongs_to :movie
  belongs_to :cast_member

  scope :ordered, -> { order(:order) }
end
