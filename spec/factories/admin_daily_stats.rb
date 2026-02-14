FactoryBot.define do
  factory :admin_daily_stat do
    sequence(:date) { |n| n.days.ago.to_date }
    new_users { 10 }
    active_users { 50 }
    new_ratings { 25 }
    new_messages { 100 }
    affiliate_clicks_count { 30 }
    affiliate_revenue_estimate { 9.0 }
    newsletter_subscribers_count { 500 }
    newsletter_unsubscribes_count { 2 }
    reports_count { 3 }
  end
end
