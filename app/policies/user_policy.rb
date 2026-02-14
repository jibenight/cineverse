class UserPolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    user == record || admin?
  end

  def follow?
    user.present? && user != record && !user.banned?
  end

  def ban?
    admin? && !record.admin?
  end

  def promote?
    admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.active
      end
    end
  end
end
