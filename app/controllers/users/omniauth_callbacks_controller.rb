module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def facebook
      oauth_callback
    end

    def twitter
      oauth_callback
    end

    def finish_signin
      return user_exists if User.find_by(email: params[:email])
      @user = User.new(email: params[:email], password: Devise.friendly_token[0, 20])
      save_user || provide_valid_email
    end

    private

    def oauth_callback
      oauth_data = request.env['omniauth.auth']
      return oauth_failure unless oauth_data

      @user = User.find_for_oauth(oauth_data)
      return sign_in_user if @user

      session['devise.omniauth'] = oauth_data.slice(:provider, :uid)
      render 'oauth/provide_email'
    end

    def save_user
      if @user.save
        @user.authorizations.where(
          provider: session['devise.omniauth']['provider'], uid: session['devise.omniauth']['uid']
        ).first_or_create
        sign_in_user
      end
    end

    def sign_in_user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    end

    def oauth_failure
      set_flash_message :alert, :failure, kind: action_name.capitalize, reason: failure_message
      redirect_to new_user_registration_path
    end

    def provide_valid_email
      flash[:alert] = 'Invalid email'
      render 'oauth/provide_email'
    end

    def user_exists
      flash[:alert] = 'User with same email already exists'
      render 'oauth/provide_email'
    end
  end
end
