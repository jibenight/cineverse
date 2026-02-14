FactoryBot.define do
  factory :rating do
    user
    movie
    score { 4.0 }
    review_text { nil }
    spoiler { false }
    reported { false }
    likes_count { 0 }

    trait :with_review do
      review_text { "Un excellent film !" }
    end

    trait :spoiler do
      review_text { "Le héros meurt à la fin." }
      spoiler { true }
    end
  end
end
