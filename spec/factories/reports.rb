FactoryBot.define do
  factory :report do
    association :reporter, factory: :user
    association :reportable, factory: :rating
    reason { :spam }
    description { "Contenu inapproprié" }
    status { :pending }
  end
end
