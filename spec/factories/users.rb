FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@cineverse.fr" }
    sequence(:username) { |n| "cinephile#{n}" }
    password { "password123" }
    password_confirmation { "password123" }
    role { :user }
    theme_preference { :dark }
    city { "Paris" }
    bio { "Passionné de cinéma" }
    confirmed_at { Time.current }
    notifications_enabled { true }

    trait :admin do
      role { :admin }
    end

    trait :premium do
      role { :premium }
    end

    trait :banned do
      banned_at { Time.current }
      ban_reason { "Violation des règles" }
    end

    trait :online do
      last_seen_at { 1.minute.ago }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
