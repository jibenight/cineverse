class ReportPolicy < ApplicationPolicy
  def create?
    user.present? && !user.banned?
  end

  def index?
    admin?
  end

  def review?
    admin?
  end

  def resolve?
    admin?
  end
end
