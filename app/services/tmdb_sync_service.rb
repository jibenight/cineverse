class TmdbSyncService
  BASE_URL = "https://api.themoviedb.org/3"

  def initialize
    @api_key = ENV.fetch("TMDB_API_KEY")
  end

  def sync_all
    sync_now_playing
    sync_upcoming
    sync_popular
    sync_genres
  end

  def sync_now_playing
    sync_movies_from_endpoint("/movie/now_playing", :now_playing)
  end

  def sync_upcoming
    sync_movies_from_endpoint("/movie/upcoming", :upcoming)
  end

  def sync_popular
    sync_movies_from_endpoint("/movie/popular", :released)
  end

  def sync_genres
    response = fetch("/genre/movie/list")
    return unless response.success?

    response.parsed_response["genres"].each do |genre_data|
      Genre.find_or_create_by(tmdb_id: genre_data["id"]) do |genre|
        genre.name = genre_data["name"]
      end
    end
  end

  def sync_movie_details(tmdb_id)
    response = fetch("/movie/#{tmdb_id}", append_to_response: "credits,videos")
    return unless response.success?

    data = response.parsed_response
    movie = Movie.find_or_initialize_by(tmdb_id: data["id"])
    movie.assign_attributes(
      title: data["title"],
      overview: data["overview"],
      poster_path: data["poster_path"],
      backdrop_path: data["backdrop_path"],
      release_date: data["release_date"],
      runtime: data["runtime"],
      vote_average: data["vote_average"],
      popularity: data["popularity"],
      original_language: data["original_language"]
    )
    movie.save!

    sync_movie_genres(movie, data["genres"]) if data["genres"]
    sync_movie_cast(movie, data.dig("credits", "cast")) if data.dig("credits", "cast")

    movie
  end

  def search(query, page: 1)
    response = fetch("/search/movie", query: query, page: page)
    return { results: [], total_pages: 0 } unless response.success?

    parsed = response.parsed_response
    {
      results: parsed["results"].map { |r| format_search_result(r) },
      total_pages: parsed["total_pages"],
      total_results: parsed["total_results"]
    }
  end

  private

  def sync_movies_from_endpoint(endpoint, status, pages: 3)
    (1..pages).each do |page|
      response = fetch(endpoint, page: page)
      next unless response.success?

      response.parsed_response["results"].each do |movie_data|
        movie = Movie.find_or_initialize_by(tmdb_id: movie_data["id"])
        movie.assign_attributes(
          title: movie_data["title"],
          overview: movie_data["overview"],
          poster_path: movie_data["poster_path"],
          backdrop_path: movie_data["backdrop_path"],
          release_date: movie_data["release_date"],
          vote_average: movie_data["vote_average"],
          popularity: movie_data["popularity"],
          original_language: movie_data["original_language"],
          status: status
        )
        movie.save!

        sync_movie_genre_ids(movie, movie_data["genre_ids"]) if movie_data["genre_ids"]
      end
    end
  end

  def sync_movie_genres(movie, genres_data)
    genre_ids = genres_data.map do |genre_data|
      Genre.find_or_create_by(tmdb_id: genre_data["id"]) { |g| g.name = genre_data["name"] }.id
    end
    movie.genre_ids = genre_ids
  end

  def sync_movie_genre_ids(movie, tmdb_genre_ids)
    genre_ids = Genre.where(tmdb_id: tmdb_genre_ids).pluck(:id)
    movie.genre_ids = genre_ids
  end

  def sync_movie_cast(movie, cast_data)
    cast_data.first(20).each_with_index do |cast, index|
      cast_member = CastMember.find_or_initialize_by(tmdb_id: cast["id"])
      cast_member.assign_attributes(
        name: cast["name"],
        profile_path: cast["profile_path"]
      )
      cast_member.save!

      MovieCastMember.find_or_create_by(movie: movie, cast_member: cast_member) do |mcm|
        mcm.character = cast["character"]
        mcm.order = index
      end
    end
  end

  def format_search_result(data)
    {
      tmdb_id: data["id"],
      title: data["title"],
      overview: data["overview"]&.truncate(200),
      poster_path: data["poster_path"],
      release_date: data["release_date"],
      vote_average: data["vote_average"]
    }
  end

  def fetch(endpoint, **params)
    HTTParty.get(
      "#{BASE_URL}#{endpoint}",
      query: params.merge(api_key: @api_key, language: "fr-FR", region: "FR"),
      timeout: 10
    )
  end
end
