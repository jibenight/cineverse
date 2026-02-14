FactoryBot.define do
  factory :user_badge do
    user
    badge
    earned_at { Time.current }
  end
end
