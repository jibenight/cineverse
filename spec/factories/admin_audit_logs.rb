FactoryBot.define do
  factory :admin_audit_log do
    association :admin, factory: [:user, :admin]
    action { "banned_user" }
    target_type { "User" }
    target_id { 1 }
    metadata { { reason: "Spam" } }
  end
end
