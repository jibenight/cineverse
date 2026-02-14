FactoryBot.define do
  factory :movie do
    sequence(:tmdb_id) { |n| n }
    sequence(:title) { |n| "Film #{n}" }
    overview { "Un film passionnant." }
    poster_path { "/poster.jpg" }
    backdrop_path { "/backdrop.jpg" }
    release_date { Date.current }
    runtime { 120 }
    vote_average { 4.0 }
    ratings_count { 0 }
    status { :now_playing }
    popularity { 50.0 }
    original_language { "fr" }

    trait :upcoming do
      status { :upcoming }
      release_date { 30.days.from_now }
      vote_average { 0.0 }
    end

    trait :released do
      status { :released }
      release_date { 6.months.ago }
    end
  end
end
