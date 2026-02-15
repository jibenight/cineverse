class SearchController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    @query = params[:q].to_s.strip
    return if @query.blank?

    @pagy, @movies = pagy(
      Movie.where("title ILIKE ?", "%#{Movie.sanitize_sql_like(@query)}%").order(popularity: :desc)
    )

    if @movies.empty?
      @tmdb_results = TmdbSyncService.new.search(@query, page: params[:page] || 1)
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
