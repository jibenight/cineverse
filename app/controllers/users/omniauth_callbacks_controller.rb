module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token, only: [:apple]

    def google_oauth2
      handle_omniauth("Google")
    end

    def github
      handle_omniauth("GitHub")
    end

    def apple
      handle_omniauth("Apple")
    end

    def failure
      redirect_to root_path, alert: "L'authentification a échoué. Veuillez réessayer."
    end

    private

    def handle_omniauth(provider_name)
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
      else
        session["devise.omniauth_data"] = request.env["omniauth.auth"].except(:extra)
        redirect_to new_user_registration_url, alert: "Un problème est survenu avec votre compte #{provider_name}."
      end
    end
  end
end
