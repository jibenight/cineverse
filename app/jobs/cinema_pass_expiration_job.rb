class CinemaPassExpirationJob < ApplicationJob
  queue_as :default

  def perform
    CinemaPass.expiring_soon.includes(:user).each do |pass|
      days_left = (pass.expiration_date - Date.current).to_i
      next unless [30, 7, 1].include?(days_left)

      Notification.create!(
        user: pass.user,
        notifiable: pass,
        action: :release_alert
      )
    end
  end
end
