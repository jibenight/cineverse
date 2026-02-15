module Users
  class RegistrationsController < Devise::RegistrationsController
    protected

    def after_sign_up_path_for(resource)
      root_path
    end

    def after_update_path_for(resource)
      settings_path
    end

    def update_resource(resource, params)
      if resource.provider.present?
        # OAuth users don't need current password to update profile
        resource.update(params.except(:current_password))
      else
        super
      end
    end
  end
end
