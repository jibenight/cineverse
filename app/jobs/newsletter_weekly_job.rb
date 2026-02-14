class NewsletterWeeklyJob < ApplicationJob
  queue_as :mailers

  def perform
    # Auto-create and send weekly newsletter campaign
    campaign = NewsletterCampaign.create!(
      subject: "CinéVerse - Sélection de la semaine #{Date.current.strftime('%d/%m/%Y')}",
      body_html: generate_weekly_html,
      body_text: generate_weekly_text,
      status: :sending,
      segment_filter: { "category" => "weekly_picks" },
      created_by: User.find_by(role: :admin)
    )

    NewsletterSendService.new(campaign).send_campaign
  end

  private

  def generate_weekly_html
    top_movies = Movie.joins(:ratings)
      .where(ratings: { created_at: 1.week.ago..Time.current })
      .group("movies.id")
      .order("AVG(ratings.score) DESC")
      .limit(5)

    ApplicationController.render(
      template: "newsletter_mailer/weekly_picks",
      layout: false,
      assigns: { movies: top_movies }
    )
  rescue StandardError
    "<h1>Sélection de la semaine</h1><p>Découvrez les films les mieux notés cette semaine sur CinéVerse !</p>"
  end

  def generate_weekly_text
    "Sélection de la semaine CinéVerse - Découvrez les films les mieux notés cette semaine !"
  end
end
