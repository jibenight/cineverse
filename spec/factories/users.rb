FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@cineverse.fr" }
    sequence(:username) { |n| "cinephile#{n}" }
    password { "password1234" }
    password_confirmation { "password1234" }
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

    trait :google_oauth do
      provider { "google_oauth2" }
      sequence(:uid) { |n| "google_#{n}" }
    end

    trait :github_oauth do
      provider { "github" }
      sequence(:uid) { |n| "github_#{n}" }
    end

    trait :apple_oauth do
      provider { "apple" }
      sequence(:uid) { |n| "apple_#{n}" }
    end
  end
end
