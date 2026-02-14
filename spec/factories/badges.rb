FactoryBot.define do
  factory :badge do
    sequence(:slug) { |n| "badge_#{n}" }
    sequence(:name) { |n| "Badge #{n}" }
    description { "A badge description" }
    icon { "🎬" }
    category { :watching }
    condition_type { "movies_rated" }
    condition_value { 10 }

    trait :cinephile_debutant do
      slug { "cinephile_debutant" }
      name { "Cinéphile débutant" }
      condition_type { "movies_rated" }
      condition_value { 10 }
    end

    trait :premiere_critique do
      slug { "premiere_critique" }
      name { "Première critique" }
      condition_type { "reviews_written" }
      condition_value { 1 }
    end

    trait :noctambule do
      slug { "noctambule" }
      name { "Noctambule" }
      condition_type { "night_rating" }
      condition_value { 1 }
    end
  end
end
