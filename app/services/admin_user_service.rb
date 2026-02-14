class AdminUserService
  Result = Struct.new(:success?, :error, keyword_init: true)

  def initialize(admin:, user:)
    @admin = admin
    @user = user
  end

  def ban(reason: nil)
    perform_action("banned_user", metadata: { reason: reason }) do
      @user.update!(banned_at: Time.current, ban_reason: reason)
    end
  end

  def unban
    perform_action("unbanned_user") do
      @user.update!(banned_at: nil, ban_reason: nil)
    end
  end

  def promote_admin
    perform_action("promoted_admin") do
      @user.update!(role: :admin)
    end
  end

  def promote_premium
    perform_action("promoted_premium") do
      @user.update!(role: :premium)
    end
  end

  def remove_premium
    perform_action("removed_premium") do
      @user.update!(role: :user)
    end
  end

  private

  def perform_action(action, metadata: {})
    ActiveRecord::Base.transaction do
      yield
      AdminAuditLog.log!(admin: @admin, action: action, target: @user, metadata: metadata)
    end

    Result.new(success?: true)
  rescue StandardError => e
    Result.new(success?: false, error: e.message)
  end
end
