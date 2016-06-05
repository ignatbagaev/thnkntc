class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    oauth_callback
  end
  
  def twitter
    oauth_callback
  end

  def finish_signin
    return user_exists if User.find_by(email: params[:email])
    
    user = User.new(email: params[:email], password: Devise.friendly_token[0, 20])
    if user.save
      auth = user.authorizations.where(provider: session['devise.omniauth']['provider'],
                                       uid:      session['devise.omniauth']['uid']).first_or_create
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      flash[:alert] = 'Invalid email'
      render 'oauth/provide_email'
    end
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
        render 'oauth/provide_email'
      end
    else
      set_flash_message :alert, :failure, kind: action_name.capitalize, reason: failure_message
      redirect_to new_user_registration_path
    end
  end

  def user_exists
    flash[:alert] = 'User with same email already exists'
    render 'oauth/provide_email'
  end
end
