require 'rails_helper'

RSpec.describe ReleaseAlert, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:movie) }
  end

  describe "validations" do
    subject { build(:release_alert) }

    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:movie_id) }
  end

  describe "scopes" do
    it ".pending returns non-notified alerts" do
      pending_alert = create(:release_alert, notified: false)
      notified_alert = create(:release_alert, notified: true)
      expect(ReleaseAlert.pending).to include(pending_alert)
      expect(ReleaseAlert.pending).not_to include(notified_alert)
    end
  end
end
