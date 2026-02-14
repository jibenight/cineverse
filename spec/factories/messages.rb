FactoryBot.define do
  factory :message do
    conversation
    user
    body { "Salut !" }
    message_type { :text }
    reported { false }

    trait :movie_share do
      message_type { :movie_share }
      body { nil }
      association :shared_movie, factory: :movie
    end

    trait :cinema_invite do
      message_type { :cinema_invite }
      body { "Je t'invite au ciné !" }
    end

    trait :discount_share do
      message_type { :discount_share }
      body { "Réduction -30% Pathé" }
    end
  end
end
