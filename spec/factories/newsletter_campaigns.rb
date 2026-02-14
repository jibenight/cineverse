FactoryBot.define do
  factory :newsletter_campaign do
    subject { "La sélection de la semaine" }
    body_html { "<h1>Cette semaine au cinéma</h1><p>Les meilleurs films.</p>" }
    body_text { "Cette semaine au cinéma - Les meilleurs films." }
    status { :draft }
    segment_filter { nil }
    association :created_by, factory: [:user, :admin]

    trait :scheduled do
      status { :scheduled }
      scheduled_at { 1.day.from_now }
    end

    trait :sent do
      status { :sent }
      sent_at { 1.day.ago }
    end

    trait :sending do
      status { :sending }
    end
  end
end
