FactoryBot.define do
  factory :watchlist_item do
    user
    movie
    position { nil }
  end
end
