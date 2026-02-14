FactoryBot.define do
  factory :release_alert do
    user
    movie
    notified { false }
  end
end
