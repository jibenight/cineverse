FactoryBot.define do
  factory :static_page do
    slug { :about }
    title { "À propos" }
    body_html { "<p>CinéVerse est une plateforme cinéma.</p>" }
  end
end
