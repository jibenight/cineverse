FactoryBot.define do
  factory :affiliate_click do
    user
    movie
    provider { :pathe }
    clicked_at { Time.current }
    user_agent { "Mozilla/5.0" }
    referer { "https://cineverse.fr" }
    ip_hash { SecureRandom.hex(16) }
  end
end
