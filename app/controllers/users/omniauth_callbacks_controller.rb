class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    oauth_callback
  end
  
  def twitter
    oauth_callback
  end

  private

  def oauth_callback
    if request.env['omniauth.auth']
      @user = User.find_for_oauth(request.env['omniauth.auth'])
      if @user
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
      else
        session['devise.omniauth'] = request.env['omniauth.auth'].slice(:provider, :uid)
        redirect_to new_user_registration_path
      end
    else
      set_flash_message :alert, :failure, kind: action_name.capitalize, reason: failure_message
      redirect_to new_user_registration_path
    end
  end
end
