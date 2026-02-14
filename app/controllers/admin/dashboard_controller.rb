module Admin
  class DashboardController < BaseController
    def index
      @period = params[:period] || "30d"
      @start_date = period_start_date(@period)

      @kpis = {
        total_users: User.count,
        new_users_week: User.where(created_at: 1.week.ago..).count,
        active_today: User.where(last_seen_at: Date.current.all_day).count,
        total_movies: Movie.count,
        ratings_week: Rating.where(created_at: 1.week.ago..).count,
        messages_today: Message.where(created_at: Date.current.all_day).count,
        active_conversations: Conversation.where(updated_at: 1.day.ago..).count,
        newsletter_active: NewsletterSubscriber.active.count,
        affiliate_clicks_month: AffiliateClick.where(clicked_at: 1.month.ago..).count,
        pending_reports: Report.pending_review.count
      }

      @stats = AdminDailyStat.where("date >= ?", @start_date).order(date: :asc)
    end

    private

    def period_start_date(period)
      case period
      when "7d" then 7.days.ago.to_date
      when "30d" then 30.days.ago.to_date
      when "90d" then 90.days.ago.to_date
      when "12m" then 12.months.ago.to_date
      else 30.days.ago.to_date
      end
    end
  end
end
