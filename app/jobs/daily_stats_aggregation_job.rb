class DailyStatsAggregationJob < ApplicationJob
  queue_as :low

  def perform(date = Date.yesterday)
    stat = AdminDailyStat.find_or_initialize_by(date: date)
    stat.assign_attributes(
      new_users: User.where(created_at: date.all_day).count,
      active_users: User.where(last_seen_at: date.all_day).count,
      new_ratings: Rating.where(created_at: date.all_day).count,
      new_messages: Message.where(created_at: date.all_day).count,
      affiliate_clicks_count: AffiliateClick.where(clicked_at: date.all_day).count,
      affiliate_revenue_estimate: calculate_affiliate_revenue(date),
      newsletter_subscribers_count: NewsletterSubscriber.active.count,
      newsletter_unsubscribes_count: NewsletterSubscriber.where(unsubscribed_at: date.all_day).count,
      reports_count: Report.where(created_at: date.all_day).count
    )
    stat.save!
  end

  private

  def calculate_affiliate_revenue(date)
    config = YAML.load_file(Rails.root.join("config", "affiliates.yml"))["providers"]
    AffiliateClick.where(clicked_at: date.all_day).group(:provider).count.sum do |provider, count|
      cpc = config.dig(provider, "estimated_cpc") || 0.25
      count * cpc
    end
  end
end
