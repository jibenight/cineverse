class MessagePolicy < ApplicationPolicy
  def create?
    user.present? && !user.banned? && !muted? && participant?
  end

  def destroy?
    owner? || admin?
  end

  def report?
    user.present? && !owner? && participant?
  end

  private

  def participant?
    record.conversation.participants.include?(user)
  end

  def muted?
    Mute.active.where(user: user).exists? ||
      Mute.active.where(user: user, conversation: record.conversation).exists?
  end
end
