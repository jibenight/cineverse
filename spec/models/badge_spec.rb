require 'rails_helper'

RSpec.describe Badge, type: :model do
  describe "associations" do
    it { is_expected.to have_many(:user_badges).dependent(:destroy) }
    it { is_expected.to have_many(:users).through(:user_badges) }
  end

  describe "validations" do
    subject { build(:badge) }

    it { is_expected.to validate_presence_of(:slug) }
    it { is_expected.to validate_uniqueness_of(:slug) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:condition_type) }
    it { is_expected.to validate_presence_of(:condition_value) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:category).with_values(watching: 0, social: 1, community: 2, loyalty: 3) }
  end
end
