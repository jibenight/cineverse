class Badge < ApplicationRecord
  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  enum :category, { watching: 0, social: 1, community: 2, loyalty: 3 }

  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true
  validates :condition_type, presence: true
  validates :condition_value, presence: true
end
