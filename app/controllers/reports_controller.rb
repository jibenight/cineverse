class ReportsController < ApplicationController
  before_action :authenticate_user!

  def create
    @report = Report.new(report_params.merge(reporter: current_user))
    authorize @report

    if @report.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("report_form", html: tag.p(I18n.t("reports.submitted"), class: "text-green-500")) }
        format.html { redirect_back fallback_location: root_path, notice: I18n.t("reports.submitted") }
      end
    else
      redirect_back fallback_location: root_path, alert: @report.errors.full_messages.join(", ")
    end
  end

  private

  def report_params
    params.require(:report).permit(:reportable_type, :reportable_id, :reason, :description)
  end
end
