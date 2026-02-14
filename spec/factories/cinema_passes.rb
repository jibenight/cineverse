FactoryBot.define do
  factory :cinema_pass do
    user
    provider { :ugc_illimite }
    pass_type { :solo }
    display_on_profile { true }
    verified { false }
    expiration_date { 1.year.from_now }

    trait :duo do
      pass_type { :duo }
    end

    trait :famille do
      pass_type { :famille }
    end

    trait :other_provider do
      provider { :other }
      provider_custom_name { "Mon Ciné Local" }
    end

    trait :expiring_soon do
      expiration_date { 15.days.from_now }
    end

    trait :expired do
      expiration_date { 1.day.ago }
    end
  end
end
