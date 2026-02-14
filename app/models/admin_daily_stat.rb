class AdminDailyStat < ApplicationRecord
  validates :date, presence: true, uniqueness: true

  scope :for_period, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :recent, ->(days = 30) { where("date >= ?", days.days.ago.to_date).order(date: :asc) }
end
