module Admin
  module Moderation
    class ReportsController < Admin::BaseController
      def index
        @reports = Report.includes(:reporter, :reportable).order(created_at: :desc)
        @reports = @reports.where(status: params[:status]) if params[:status].present?
        @pagy, @reports = pagy(@reports)
      end

      def show
        @report = Report.find(params[:id])
      end

      def dismiss
        @report = Report.find(params[:id])
        @report.update!(status: :dismissed, reviewed_by: current_user, reviewed_at: Time.current)
        audit_log!(action: "dismissed_report", target: @report)
        redirect_to admin_moderation_reports_path, notice: "Signalement rejeté."
      end

      def hide_content
        @report = Report.find(params[:id])
        @report.reportable.update!(reported: true) if @report.reportable.respond_to?(:reported)
        @report.update!(status: :resolved, reviewed_by: current_user, reviewed_at: Time.current)
        audit_log!(action: "hid_content", target: @report.reportable)
        redirect_to admin_moderation_reports_path, notice: "Contenu masqué."
      end

      def delete_content
        @report = Report.find(params[:id])
        target = @report.reportable
        @report.update!(status: :resolved, reviewed_by: current_user, reviewed_at: Time.current)
        audit_log!(action: "deleted_content", target: target, metadata: { type: target.class.name })
        target.destroy
        redirect_to admin_moderation_reports_path, notice: "Contenu supprimé."
      end

      def mute_user
        @report = Report.find(params[:id])
        user = @report.reportable.respond_to?(:user) ? @report.reportable.user : @report.reportable
        Mute.create!(user: user, muted_by: current_user, scope: :global, duration: params[:duration] || :twenty_four_hours, reason: "Moderation action from report ##{@report.id}")
        @report.update!(status: :resolved, reviewed_by: current_user, reviewed_at: Time.current)
        audit_log!(action: "muted_user", target: user, metadata: { duration: params[:duration] })
        redirect_to admin_moderation_reports_path, notice: "Utilisateur muté."
      end

      def ban_user
        @report = Report.find(params[:id])
        user = @report.reportable.respond_to?(:user) ? @report.reportable.user : @report.reportable
        user.update!(banned_at: Time.current, ban_reason: "Banned from report ##{@report.id}")
        @report.update!(status: :resolved, reviewed_by: current_user, reviewed_at: Time.current)
        audit_log!(action: "banned_user", target: user)
        redirect_to admin_moderation_reports_path, notice: "Utilisateur banni."
      end
    end
  end
end
