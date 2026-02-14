module Admin
  module Content
    class MoviesController < Admin::BaseController
      def index
        @pagy, @movies = pagy(Movie.order(updated_at: :desc))
      end

      def show
        @movie = Movie.find(params[:id])
      end

      def sync
        @movie = Movie.find(params[:id])
        TmdbSyncService.new.sync_movie_details(@movie.tmdb_id)
        audit_log!(action: "synced_movie", target: @movie)
        redirect_to admin_content_movie_path(@movie), notice: "Film resynchronisé."
      end

      def hide
        @movie = Movie.find(params[:id])
        @movie.update!(status: :released)
        audit_log!(action: "hid_movie", target: @movie)
        redirect_to admin_content_movies_path, notice: "Film masqué."
      end

      def sync_all
        TmdbSyncJob.perform_later
        audit_log!(action: "synced_all_movies")
        redirect_to admin_content_movies_path, notice: "Synchronisation lancée en arrière-plan."
      end
    end
  end
end
