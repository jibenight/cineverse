class CastMember < ApplicationRecord
  has_many :movie_cast_members, dependent: :destroy
  has_many :movies, through: :movie_cast_members

  validates :tmdb_id, presence: true, uniqueness: true
  validates :name, presence: true
end
