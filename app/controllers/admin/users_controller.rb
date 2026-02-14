module Admin
  class UsersController < BaseController
    def index
      @users = User.all
      @users = @users.where(role: params[:role]) if params[:role].present?
      @users = @users.where("username ILIKE :q OR email ILIKE :q", q: "%#{params[:q]}%") if params[:q].present?
      @users = @users.banned if params[:status] == "banned"
      @users = @users.active if params[:status] == "active"
      @pagy, @users = pagy(@users.order(created_at: :desc))
    end

    def show
      @user = User.find(params[:id])
      @recent_ratings = @user.ratings.includes(:movie).order(created_at: :desc).limit(10)
      @reports = Report.includes(:reporter).where(reportable: @user.ratings).or(Report.includes(:reporter).where(reportable: @user.messages)).order(created_at: :desc)
      @audit_logs = AdminAuditLog.where(target_type: "User", target_id: @user.id).order(created_at: :desc).limit(20)
    end

    def ban
      @user = User.find(params[:id])
      result = admin_user_service(@user).ban(reason: params[:reason])
      if result.success?
        redirect_to admin_user_path(@user), notice: "Utilisateur banni."
      else
        redirect_to admin_user_path(@user), alert: result.error
      end
    end

    def unban
      @user = User.find(params[:id])
      result = admin_user_service(@user).unban
      if result.success?
        redirect_to admin_user_path(@user), notice: "Utilisateur débanni."
      else
        redirect_to admin_user_path(@user), alert: result.error
      end
    end

    def promote_admin
      @user = User.find(params[:id])
      result = admin_user_service(@user).promote_admin
      if result.success?
        redirect_to admin_user_path(@user), notice: "Utilisateur promu admin."
      else
        redirect_to admin_user_path(@user), alert: result.error
      end
    end

    def promote_premium
      @user = User.find(params[:id])
      result = admin_user_service(@user).promote_premium
      if result.success?
        redirect_to admin_user_path(@user), notice: "Utilisateur passé premium."
      else
        redirect_to admin_user_path(@user), alert: result.error
      end
    end

    def remove_premium
      @user = User.find(params[:id])
      result = admin_user_service(@user).remove_premium
      if result.success?
        redirect_to admin_user_path(@user), notice: "Premium retiré."
      else
        redirect_to admin_user_path(@user), alert: result.error
      end
    end

    def delete_account
      @user = User.find(params[:id])
      audit_log!(action: "deleted_user", target: @user, metadata: { email: @user.email })
      @user.destroy
      redirect_to admin_users_path, notice: "Compte supprimé."
    end

    def export_csv
      @users = User.all
      csv_data = CSV.generate(headers: true) do |csv|
        csv << %w[id email username role city created_at last_seen_at banned_at]
        @users.find_each do |user|
          csv << [user.id, user.email, user.username, user.role, user.city, user.created_at, user.last_seen_at, user.banned_at]
        end
      end

      send_data csv_data, filename: "users_#{Date.current}.csv", type: "text/csv"
    end

    private

    def admin_user_service(user)
      AdminUserService.new(admin: current_user, user: user)
    end
  end
end
