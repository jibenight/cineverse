class NewsletterSendService
  def initialize(campaign)
    @campaign = campaign
    @config = YAML.load_file(Rails.root.join("config", "newsletter.yml"))
  end

  def send_campaign
    @campaign.update!(status: :sending)
    subscribers = target_subscribers

    subscribers.find_in_batches(batch_size: @config["batch_size"]) do |batch|
      batch.each do |subscriber|
        NewsletterMailer.campaign_email(@campaign, subscriber).deliver_later
      end
      sleep(batch.size.to_f / @config["rate_limit_per_second"])
    end

    @campaign.update!(status: :sent, sent_at: Time.current)
    create_initial_stats(subscribers.count)
  end

  private

  def target_subscribers
    scope = NewsletterSubscriber.active

    if @campaign.segment_filter.present?
      filter = @campaign.segment_filter
      scope = apply_segment_filter(scope, filter)
    end

    scope
  end

  def apply_segment_filter(scope, filter)
    if filter["category"].present?
      scope = scope.subscribed_to(filter["category"])
    end
    if filter["min_ratings"].present?
      user_ids = Rating.group(:user_id).having("COUNT(*) >= ?", filter["min_ratings"]).pluck(:user_id)
      scope = scope.where(user_id: user_ids)
    end
    if filter["min_account_age_months"].present?
      scope = scope.joins(:user).where("users.created_at <= ?", filter["min_account_age_months"].months.ago)
    end
    scope
  end

  def create_initial_stats(total)
    NewsletterCampaignStat.create!(
      campaign: @campaign,
      total_sent: total,
      total_opened: 0,
      total_clicked: 0,
      total_bounced: 0,
      total_unsubscribed: 0
    )
  end
end
