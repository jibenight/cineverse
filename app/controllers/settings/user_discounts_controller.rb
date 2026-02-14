module Settings
  class UserDiscountsController < ApplicationController
    before_action :authenticate_user!

    def new
      @discount = UserDiscount.new
      authorize @discount
    end

    def create
      @discount = current_user.user_discounts.build(discount_params)
      authorize @discount

      if @discount.save
        redirect_to settings_path, notice: I18n.t("flash.discount.created")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @discount = current_user.user_discounts.find(params[:id])
      authorize @discount
    end

    def update
      @discount = current_user.user_discounts.find(params[:id])
      authorize @discount

      if @discount.update(discount_params)
        redirect_to settings_path, notice: I18n.t("flash.discount.updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @discount = current_user.user_discounts.find(params[:id])
      authorize @discount
      @discount.destroy
      redirect_to settings_path, notice: I18n.t("flash.discount.destroyed")
    end

    private

    def discount_params
      params.require(:user_discount).permit(:discount_type, :label, :description, :shareable)
    end
  end
end
