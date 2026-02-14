class NewsletterCampaignPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end

  def update?
    admin? && (record.draft? || record.scheduled?)
  end

  def destroy?
    admin? && record.draft?
  end

  def send_campaign?
    admin? && (record.draft? || record.scheduled?)
  end

  def cancel?
    admin? && record.scheduled?
  end
end
