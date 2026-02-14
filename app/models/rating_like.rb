class RatingLike < ApplicationRecord
  belongs_to :user
  belongs_to :rating, counter_cache: :likes_count

  validates :user_id, uniqueness: { scope: :rating_id }
end
