class WatchlistsController < ApplicationController
  before_action :authenticate_user!
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def show
    @watchlist_items = current_user.watchlist_items.includes(:movie).ordered
  end

  def reorder
    params[:item_ids].each_with_index do |id, index|
      current_user.watchlist_items.find(id).update!(position: index + 1)
    end
    head :ok
  end
end
