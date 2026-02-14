FactoryBot.define do
  factory :cast_member do
    sequence(:tmdb_id) { |n| 1000 + n }
    sequence(:name) { |n| "Acteur #{n}" }
    profile_path { "/profile.jpg" }
  end
end
