class CinemaPassPolicy < ApplicationPolicy
  def create?
    user.present? && !user.banned?
  end

  def update?
    owner? && !user.banned?
  end

  def destroy?
    owner? || admin?
  end

  private

  def owner?
    record.user_id == user.id
  end
end
