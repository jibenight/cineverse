require 'rails_helper'

RSpec.describe AffiliateClick, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.to belong_to(:movie) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:provider) }
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:provider).with_values(pathe: 0, ugc: 1, mk2: 2, cgr: 3, kinepolis: 4) }
  end
end
