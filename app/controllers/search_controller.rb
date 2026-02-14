class SearchController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    @query = params[:q].to_s.strip
    return if @query.blank?

    if params[:source] == "tmdb"
      @results = TmdbSyncService.new.search(@query, page: params[:page] || 1)
    else
      @pagy, @movies = pagy(
        Movie.where("title ILIKE ?", "%#{Movie.sanitize_sql_like(@query)}%").order(popularity: :desc)
      )
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
