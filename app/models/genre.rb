class Genre < ApplicationRecord
  has_many :movie_genres, dependent: :destroy
  has_many :movies, through: :movie_genres

  validates :name, presence: true
  validates :tmdb_id, presence: true, uniqueness: true
end
