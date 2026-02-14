class AffiliateRedirectsController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def show
    movie = Movie.find(params[:movie_id])
    provider = params[:provider]
    service = AffiliateLinksService.new
    links = service.links_for(movie, user: current_user)
    link = links.find { |l| l[:provider_key] == provider }

    if link
      AffiliateClick.create(
        user: current_user,
        movie: movie,
        provider: provider,
        clicked_at: Time.current,
        user_agent: request.user_agent,
        referer: request.referer,
        ip_hash: Digest::SHA256.hexdigest(request.remote_ip)
      )
      redirect_to link[:url], allow_other_host: true, status: 302
    else
      redirect_to movie_path(movie), alert: "Provider not found"
    end
  end
end
