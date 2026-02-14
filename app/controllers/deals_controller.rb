class DealsController < ApplicationController
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    @discounts = UserDiscount.shareable.includes(:user)
    @discounts = @discounts.joins(:user).where(users: { city: params[:city] }) if params[:city].present?
    @discounts = @discounts.where(discount_type: params[:type]) if params[:type].present?
    @pagy, @discounts = pagy(@discounts)
  end
end
