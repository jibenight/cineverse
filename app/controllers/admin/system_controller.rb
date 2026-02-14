module Admin
  class SystemController < BaseController
    def audit_log
      @pagy, @logs = pagy(AdminAuditLog.includes(:admin).recent)
    end

    def health
      @checks = {
        postgresql: check_postgresql,
        redis: check_redis,
        sidekiq: check_sidekiq
      }
    end

    def tmdb_status
      @last_sync = AdminAuditLog.where(action: "synced_all_movies").order(created_at: :desc).first
      @movies_count = Movie.count
      @last_updated = Movie.maximum(:updated_at)
    end

    def newsletter_status
      @last_campaign = NewsletterCampaign.where(status: :sent).order(sent_at: :desc).first
      @active_subscribers = NewsletterSubscriber.active.count
      @pending_subscribers = NewsletterSubscriber.pending.count
    end

    private

    def check_postgresql
      ActiveRecord::Base.connection.execute("SELECT 1")
      { status: "ok", message: "Connected" }
    rescue StandardError => e
      { status: "error", message: e.message }
    end

    def check_redis
      Redis.new(url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0")).ping
      { status: "ok", message: "Connected" }
    rescue StandardError => e
      { status: "error", message: e.message }
    end

    def check_sidekiq
      stats = Sidekiq::Stats.new
      { status: "ok", message: "#{stats.processes_size} processes, #{stats.workers_size} busy" }
    rescue StandardError => e
      { status: "error", message: e.message }
    end
  end
end
