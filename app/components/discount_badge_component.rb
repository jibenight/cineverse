class DiscountBadgeComponent < ViewComponent::Base
  def initialize(discount:)
    @discount = discount
  end

  def type_label
    I18n.t("discounts.types.#{@discount.discount_type}")
  end
end
