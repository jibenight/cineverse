class BookingCardComponent < ViewComponent::Base
  def initialize(movie:, affiliate_links:, current_user: nil)
    @movie = movie
    @affiliate_links = affiliate_links
    @current_user = current_user
  end

  def render?
    @movie.now_playing? && @affiliate_links.present?
  end
end
