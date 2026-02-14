class AdminPolicy < ApplicationPolicy
  def dashboard?
    admin?
  end

  def manage_users?
    admin?
  end

  def manage_newsletter?
    admin?
  end

  def manage_affiliates?
    admin?
  end

  def manage_moderation?
    admin?
  end

  def manage_content?
    admin?
  end

  def view_system?
    admin?
  end
end
