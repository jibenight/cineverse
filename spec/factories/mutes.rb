FactoryBot.define do
  factory :mute do
    user
    association :muted_by, factory: [:user, :admin]
    scope { :global }
    duration { :one_hour }
    reason { "Spam detected" }

    trait :permanent do
      duration { :permanent }
    end

    trait :conversation_scope do
      scope { :conversation }
      conversation
    end
  end
end
