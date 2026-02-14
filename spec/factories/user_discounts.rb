FactoryBot.define do
  factory :user_discount do
    user
    discount_type { :student }
    label { "Tarif étudiant" }
    description { "-30% sur toutes les séances" }
    shareable { true }
  end
end
