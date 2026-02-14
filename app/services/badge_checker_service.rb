class BadgeCheckerService
  BADGE_RULES = {
    "cinephile_debutant" => { condition_type: "movies_rated", condition_value: 10 },
    "cinephile_confirme" => { condition_type: "movies_rated", condition_value: 50 },
    "cinephile_expert" => { condition_type: "movies_rated", condition_value: 100 },
    "premiere_critique" => { condition_type: "reviews_written", condition_value: 1 },
    "critique_prolifique" => { condition_type: "reviews_written", condition_value: 25 },
    "aime_communaute" => { condition_type: "likes_received", condition_value: 50 },
    "sociable" => { condition_type: "followers_count", condition_value: 10 },
    "influenceur_cine" => { condition_type: "followers_count", condition_value: 100 },
    "membre_fidele" => { condition_type: "account_age_days", condition_value: 365 },
    "noctambule" => { condition_type: "night_rating", condition_value: 1 },
    "binge_watcher" => { condition_type: "daily_ratings", condition_value: 5 }
  }.freeze

  def initialize(user)
    @user = user
  end

  def check_all
    newly_earned = []
    existing_badge_ids = @user.user_badges.pluck(:badge_id)

    Badge.find_each do |badge|
      next if existing_badge_ids.include?(badge.id)
      if earned?(badge)
        begin
          user_badge = @user.user_badges.find_or_create_by(badge: badge) do |ub|
            ub.earned_at = Time.current
          end
          newly_earned << badge if user_badge.previously_new_record?
        rescue ActiveRecord::RecordNotUnique
          # Another process already created this badge, skip
        end
      end
    end

    newly_earned
  end

  private

  def earned?(badge)
    case badge.condition_type
    when "movies_rated"
      @user.ratings.count >= badge.condition_value
    when "reviews_written"
      @user.ratings.with_review.count >= badge.condition_value
    when "likes_received"
      @user.ratings.sum(:likes_count) >= badge.condition_value
    when "followers_count"
      @user.followers.count >= badge.condition_value
    when "account_age_days"
      @user.created_at <= badge.condition_value.days.ago
    when "night_rating"
      @user.ratings.where("EXTRACT(HOUR FROM created_at) >= 0 AND EXTRACT(HOUR FROM created_at) < 5").exists?
    when "daily_ratings"
      @user.ratings.group("DATE(created_at)").having("COUNT(*) >= ?", badge.condition_value).exists?
    else
      false
    end
  end
end
