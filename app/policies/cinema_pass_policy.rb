class CinemaPassPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    owner?
  end

  def destroy?
    owner? || admin?
  end

  private

  def owner?
    record.user_id == user.id
  end
end
