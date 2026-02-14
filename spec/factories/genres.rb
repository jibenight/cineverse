FactoryBot.define do
  factory :genre do
    sequence(:name) { |n| "Genre #{n}" }
    sequence(:tmdb_id) { |n| 100 + n }
  end
end
