require 'rails_helper'

RSpec.describe Mute, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:muted_by).class_name("User") }
    it { is_expected.to belong_to(:conversation).optional }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:reason) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:scope).with_values(global: 0, conversation: 1).with_prefix(true) }
    it { is_expected.to define_enum_for(:duration).with_values(one_hour: 0, twenty_four_hours: 1, seven_days: 2, permanent: 3) }
  end

  describe "callbacks" do
    it "sets expires_at for one_hour duration" do
      mute = create(:mute, duration: :one_hour)
      expect(mute.expires_at).to be_within(5.seconds).of(1.hour.from_now)
    end

    it "sets expires_at for twenty_four_hours duration" do
      mute = create(:mute, duration: :twenty_four_hours)
      expect(mute.expires_at).to be_within(5.seconds).of(24.hours.from_now)
    end

    it "sets expires_at for seven_days duration" do
      mute = create(:mute, duration: :seven_days)
      expect(mute.expires_at).to be_within(5.seconds).of(7.days.from_now)
    end

    it "sets expires_at to nil for permanent duration" do
      mute = create(:mute, :permanent)
      expect(mute.expires_at).to be_nil
    end
  end

  describe "#active?" do
    it "returns true when expires_at is in the future" do
      mute = build(:mute, expires_at: 1.hour.from_now)
      expect(mute.active?).to be true
    end

    it "returns false when expires_at is in the past" do
      mute = build(:mute, expires_at: 1.hour.ago)
      expect(mute.active?).to be false
    end

    it "returns true when expires_at is nil (permanent)" do
      mute = build(:mute, expires_at: nil)
      expect(mute.active?).to be true
    end
  end

  describe "scopes" do
    it ".active returns only active mutes" do
      active_mute = create(:mute, expires_at: 1.hour.from_now)
      expired_mute = create(:mute)
      expired_mute.update_column(:expires_at, 1.hour.ago)
      expect(Mute.active).to include(active_mute)
      expect(Mute.active).not_to include(expired_mute)
    end
  end
end
