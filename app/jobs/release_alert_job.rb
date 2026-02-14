class ReleaseAlertJob < ApplicationJob
  queue_as :default

  def perform
    movies_releasing_today = Movie.where(release_date: Date.current, status: :upcoming)

    movies_releasing_today.each do |movie|
      movie.update!(status: :now_playing)

      movie.release_alerts.pending.includes(:user).each do |alert|
        Notification.create!(
          user: alert.user,
          notifiable: movie,
          action: :release_alert
        )
        alert.update!(notified: true)
      end
    end
  end
end
