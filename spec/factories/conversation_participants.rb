FactoryBot.define do
  factory :conversation_participant do
    conversation
    user
    role { :member }
    muted { false }
    last_read_at { Time.current }
    joined_at { Time.current }

    trait :admin do
      role { :admin }
    end
  end
end
