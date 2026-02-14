require 'rails_helper'

RSpec.describe UserDiscount, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:discount_type) }
    it { is_expected.to validate_presence_of(:label) }
  end

  describe "enums" do
    it {
      is_expected.to define_enum_for(:discount_type).with_values(
        student: 0, senior: 1, unemployed: 2, large_family: 3,
        disabled: 4, military: 5, ce: 6, custom: 7
      )
    }
  end

  describe "scopes" do
    it ".shareable returns only shareable discounts" do
      shareable = create(:user_discount, shareable: true)
      private_discount = create(:user_discount, shareable: false)
      expect(UserDiscount.shareable).to include(shareable)
      expect(UserDiscount.shareable).not_to include(private_discount)
    end
  end
end
