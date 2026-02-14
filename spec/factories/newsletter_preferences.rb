FactoryBot.define do
  factory :newsletter_preference do
    association :subscriber, factory: :newsletter_subscriber
    category { :weekly_picks }
    enabled { true }
  end
end
