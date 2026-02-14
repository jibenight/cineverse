class MovieCardComponent < ViewComponent::Base
  def initialize(movie:, show_rating: true)
    @movie = movie
    @show_rating = show_rating
  end

  def poster_url
    @movie.poster_path ? "https://image.tmdb.org/t/p/w342#{@movie.poster_path}" : "placeholder_poster.png"
  end

  def year
    @movie.release_date&.year
  end

  def primary_genre
    @movie.genres.first&.name
  end
end
