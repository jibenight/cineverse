module Admin
  class AffiliatesController < BaseController
    def index
      @period = params[:period] || "30d"
      @start_date = period_start_date(@period)

      @clicks_by_provider = AffiliateClick.where("clicked_at >= ?", @start_date).group(:provider).count
      @clicks_by_day = AffiliateClick.where("clicked_at >= ?", @start_date).group_by_day(:clicked_at).count
      @recent_clicks = AffiliateClick.includes(:user, :movie).order(clicked_at: :desc).limit(50)

      config = YAML.safe_load_file(Rails.root.join("config", "affiliates.yml"))["providers"]
      @estimated_revenue = @clicks_by_provider.sum { |provider, count| count * (config.dig(provider, "estimated_cpc") || 0.25) }
    end

    def export_csv
      clicks = AffiliateClick.includes(:user, :movie).order(clicked_at: :desc)
      csv_data = CSV.generate(headers: true) do |csv|
        csv << %w[id user_email movie_title provider clicked_at]
        clicks.find_each do |click|
          csv << [click.id, click.user&.email, click.movie&.title, click.provider, click.clicked_at]
        end
      end
      send_data csv_data, filename: "affiliate_clicks_#{Date.current}.csv", type: "text/csv"
    end

    private

    def period_start_date(period)
      case period
      when "7d" then 7.days.ago
      when "30d" then 30.days.ago
      when "90d" then 90.days.ago
      when "12m" then 12.months.ago
      else 30.days.ago
      end
    end
  end
end
