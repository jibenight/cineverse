class UserDiscount < ApplicationRecord
  belongs_to :user

  enum :discount_type, {
    student: 0, senior: 1, unemployed: 2, large_family: 3,
    disabled: 4, military: 5, ce: 6, custom: 7
  }

  validates :discount_type, presence: true
  validates :label, presence: true

  scope :shareable, -> { where(shareable: true) }
end
