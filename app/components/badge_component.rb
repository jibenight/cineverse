class BadgeComponent < ViewComponent::Base
  def initialize(badge:, earned_at: nil, size: :md)
    @badge = badge
    @earned_at = earned_at
    @size = size
  end
end
