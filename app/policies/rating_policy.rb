class RatingPolicy < ApplicationPolicy
  def create?
    user.present? && !user.banned?
  end

  def update?
    owner? && !user.banned?
  end

  def destroy?
    owner? || admin?
  end

  def like?
    user.present? && !owner? && !user.banned?
  end

  def report?
    user.present? && !owner?
  end
end
