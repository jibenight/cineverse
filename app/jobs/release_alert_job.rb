class ReleaseAlertJob < ApplicationJob
  queue_as :default

  def perform
    movies_releasing_today = Movie.where(release_date: Date.current, status: :upcoming)

    movies_releasing_today.each do |movie|
      ActiveRecord::Base.transaction do
        # Guard: skip if another process already updated this movie
        locked_movie = Movie.lock.find(movie.id)
        next unless locked_movie.status.to_s == "upcoming"

        locked_movie.update!(status: :now_playing)

        locked_movie.release_alerts.where(notified: false).includes(:user).each do |alert|
          Notification.create!(
            user: alert.user,
            notifiable: locked_movie,
            action: :release_alert
          )
          alert.update!(notified: true)
        end
      end
    end
  end
end
