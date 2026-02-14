FactoryBot.define do
  factory :conversation do
    title { nil }
    is_group { false }
    association :created_by, factory: :user

    trait :group do
      title { "Salon cinéma" }
      is_group { true }
    end
  end
end
