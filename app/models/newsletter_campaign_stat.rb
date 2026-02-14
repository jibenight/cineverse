class NewsletterCampaignStat < ApplicationRecord
  belongs_to :campaign, class_name: "NewsletterCampaign"

  def open_rate
    return 0 if total_sent.zero?
    (total_opened.to_f / total_sent * 100).round(1)
  end

  def click_rate
    return 0 if total_sent.zero?
    (total_clicked.to_f / total_sent * 100).round(1)
  end

  def bounce_rate
    return 0 if total_sent.zero?
    (total_bounced.to_f / total_sent * 100).round(1)
  end

  def unsubscribe_rate
    return 0 if total_sent.zero?
    (total_unsubscribed.to_f / total_sent * 100).round(1)
  end
end
