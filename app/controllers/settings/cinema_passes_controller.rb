module Settings
  class CinemaPassesController < ApplicationController
    before_action :authenticate_user!

    def new
      @cinema_pass = CinemaPass.new
      authorize @cinema_pass
    end

    def create
      @cinema_pass = current_user.cinema_passes.build(cinema_pass_params)
      authorize @cinema_pass

      if @cinema_pass.save
        redirect_to settings_path, notice: I18n.t("flash.cinema_pass.created")
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @cinema_pass = current_user.cinema_passes.find(params[:id])
      authorize @cinema_pass
    end

    def update
      @cinema_pass = current_user.cinema_passes.find(params[:id])
      authorize @cinema_pass

      if @cinema_pass.update(cinema_pass_params)
        redirect_to settings_path, notice: I18n.t("flash.cinema_pass.updated")
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @cinema_pass = current_user.cinema_passes.find(params[:id])
      authorize @cinema_pass
      @cinema_pass.destroy
      redirect_to settings_path, notice: I18n.t("flash.cinema_pass.destroyed")
    end

    private

    def cinema_pass_params
      params.require(:cinema_pass).permit(:provider, :provider_custom_name, :pass_type, :display_on_profile, :expiration_date)
    end
  end
end
