FactoryBot.define do
  factory :newsletter_campaign_stat do
    association :campaign, factory: :newsletter_campaign
    total_sent { 1000 }
    total_opened { 350 }
    total_clicked { 120 }
    total_bounced { 10 }
    total_unsubscribed { 5 }
  end
end
