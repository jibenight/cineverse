class BadgeCheckJob < ApplicationJob
  queue_as :low

  def perform(user_id)
    user = User.find(user_id)
    BadgeCheckerService.new(user).check_all
  end
end
