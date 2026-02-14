class AdminAuditLog < ApplicationRecord
  belongs_to :admin, class_name: "User"

  scope :recent, -> { order(created_at: :desc) }

  def self.log!(admin:, action:, target: nil, metadata: {})
    create!(
      admin: admin,
      action: action,
      target_type: target&.class&.name,
      target_id: target&.id,
      metadata: metadata
    )
  end
end
