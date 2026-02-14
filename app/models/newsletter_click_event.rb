class NewsletterClickEvent < ApplicationRecord
  belongs_to :campaign, class_name: "NewsletterCampaign"
  belongs_to :subscriber, class_name: "NewsletterSubscriber"
end
