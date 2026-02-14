require 'rails_helper'

RSpec.describe Report, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:reporter).class_name("User") }
    it { is_expected.to belong_to(:reportable) }
    it { is_expected.to belong_to(:reviewed_by).class_name("User").optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:reason) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:reason).with_values(spam: 0, harassment: 1, spoiler: 2, inappropriate: 3, other: 4) }
    it { is_expected.to define_enum_for(:status).with_values(pending: 0, reviewed: 1, resolved: 2, dismissed: 3) }
  end

  describe "scopes" do
    it ".pending_review returns only pending reports" do
      pending = create(:report, status: :pending)
      resolved = create(:report, status: :resolved)
      expect(Report.pending_review).to include(pending)
      expect(Report.pending_review).not_to include(resolved)
    end
  end
end
