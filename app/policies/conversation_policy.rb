class ConversationPolicy < ApplicationPolicy
  def show?
    participant? || admin?
  end

  def create?
    user.present? && !user.banned?
  end

  def update?
    conversation_admin? || admin?
  end

  def destroy?
    conversation_admin? || admin?
  end

  private

  def participant?
    record.participants.include?(user)
  end

  def conversation_admin?
    record.conversation_participants.find_by(user: user)&.admin?
  end
end
