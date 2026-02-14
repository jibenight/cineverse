class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def new?
    create?
  end

  def update?
    user.present? && (owner? || admin?)
  end

  def edit?
    update?
  end

  def destroy?
    user.present? && (owner? || admin?)
  end

  private

  def admin?
    user&.admin?
  end

  def owner?
    record.respond_to?(:user_id) && record.user_id == user&.id
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end

    private

    attr_reader :user, :scope
  end
end
