FactoryBot.define do
  factory :newsletter_click_event do
    association :campaign, factory: :newsletter_campaign
    association :subscriber, factory: :newsletter_subscriber
    url { "https://cineverse.fr/movies/1" }
    clicked_at { Time.current }
  end
end
