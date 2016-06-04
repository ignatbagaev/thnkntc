class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_callback

  def facebook; end
  def twitter; end

  private

  def oauth_callback
    return unless request.env['omniauth.auth']
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.capitalize) if is_navigational_format?
    else
      session['devise.omniauth'] = request.env['omniauth.auth'].slice(:provider, :uid)
      redirect_to new_user_registration_path
    end
  end
end
