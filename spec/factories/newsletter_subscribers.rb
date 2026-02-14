FactoryBot.define do
  factory :newsletter_subscriber do
    sequence(:email) { |n| "subscriber#{n}@example.com" }
    first_name { "Jean" }
    status { :pending }
    source { :footer_form }

    trait :active do
      status { :active }
      confirmed_at { Time.current }
    end

    trait :unsubscribed do
      status { :unsubscribed }
      unsubscribed_at { Time.current }
    end

    trait :bounced do
      status { :bounced }
    end

    trait :with_user do
      user
    end
  end
end
