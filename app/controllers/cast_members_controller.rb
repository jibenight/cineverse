class CastMembersController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def show
    @cast_member = CastMember.find(params[:id])
    @movies = @cast_member.movies.includes(:genres).order(release_date: :desc)
  end
end
