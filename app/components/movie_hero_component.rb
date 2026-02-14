class MovieHeroComponent < ViewComponent::Base
  def initialize(movie:)
    @movie = movie
  end

  def backdrop_url
    @movie.backdrop_path ? "https://image.tmdb.org/t/p/w1280#{@movie.backdrop_path}" : nil
  end

  def poster_url
    @movie.poster_path ? "https://image.tmdb.org/t/p/w342#{@movie.poster_path}" : "placeholder_poster.png"
  end

  def runtime_display
    return nil unless @movie.runtime&.positive?
    hours = @movie.runtime / 60
    minutes = @movie.runtime % 60
    "#{hours}h#{minutes.to_s.rjust(2, '0')}"
  end
end
