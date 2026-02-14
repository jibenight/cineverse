module Admin
  module Moderation
    class MutesController < Admin::BaseController
      def index
        @pagy, @mutes = pagy(Mute.active.includes(:user, :muted_by).order(created_at: :desc))
      end

      def destroy
        @mute = Mute.find(params[:id])
        audit_log!(action: "removed_mute", target: @mute.user)
        @mute.destroy
        redirect_to admin_moderation_mutes_path, notice: "Mute levé."
      end
    end
  end
end
