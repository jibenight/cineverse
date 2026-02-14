module Admin
  class BaseController < ApplicationController
    before_action :authenticate_admin!
    layout "admin"

    skip_after_action :verify_authorized
    skip_after_action :verify_policy_scoped

    private

    def authenticate_admin!
      authenticate_user!
      redirect_to root_path, alert: I18n.t("pundit.not_authorized") unless current_user&.admin?
    end

    def audit_log!(action:, target: nil, metadata: {})
      AdminAuditLog.log!(admin: current_user, action: action, target: target, metadata: metadata)
    end
  end
end
