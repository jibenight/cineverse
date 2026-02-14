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
    end

    def ban
      @user = User.find(params[:id])
      @user.update!(banned_at: Time.current, ban_reason: params[:reason])
      audit_log!(action: "banned_user", target: @user, metadata: { reason: params[:reason] })
      redirect_to admin_user_path(@user), notice: "Utilisateur banni."
    end

    def unban
      @user = User.find(params[:id])
      @user.update!(banned_at: nil, ban_reason: nil)
      audit_log!(action: "unbanned_user", target: @user)
      redirect_to admin_user_path(@user), notice: "Utilisateur débanni."
    end

    def promote_admin
      @user = User.find(params[:id])
      @user.update!(role: :admin)
      audit_log!(action: "promoted_admin", target: @user)
      redirect_to admin_user_path(@user), notice: "Utilisateur promu admin."
    end

    def promote_premium
      @user = User.find(params[:id])
      @user.update!(role: :premium)
      audit_log!(action: "promoted_premium", target: @user)
      redirect_to admin_user_path(@user), notice: "Utilisateur passé premium."
    end

    def remove_premium
      @user = User.find(params[:id])
      @user.update!(role: :user)
      audit_log!(action: "removed_premium", target: @user)
      redirect_to admin_user_path(@user), notice: "Premium retiré."
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
  end
end
