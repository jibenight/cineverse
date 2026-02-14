class Report < ApplicationRecord
  belongs_to :reporter, class_name: "User"
  belongs_to :reportable, polymorphic: true
  belongs_to :reviewed_by, class_name: "User", optional: true

  enum :reason, { spam: 0, harassment: 1, spoiler: 2, inappropriate: 3, other: 4 }
  enum :status, { pending: 0, reviewed: 1, resolved: 2, dismissed: 3 }

  validates :reason, presence: true

  scope :pending_review, -> { where(status: :pending) }
  scope :recent, -> { order(created_at: :desc) }
end
