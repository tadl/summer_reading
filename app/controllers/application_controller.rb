class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :authenticate_user!
  helper_method :check_for_admin
  helper_method :check_for_approved
  private
  def current_user
    @current_user ||= Admin.find(session[:user_id]) if session[:user_id]
  end
    
  def authenticate_user!
      if !current_user
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
  end

  def block_non_tadl_user!
      if current_user.email == 'srcvol@tadl.org'
        redirect_to root_url, :alert => 'Please ask a TADL staff member if you need to make changes to an account or need to download information in CSV format'
      end
  end

  def check_for_admin
    super_users = ENV["super_users"].split(',')
    if super_users.include? @current_user.email
      return true
    end
  end

  def check_for_approved
    super_users = ENV["super_users"].split(',') 
    if current_user.role == 'approved'
      return true
    elsif super_users.include? @current_user.email
      return true
    end
  end

  # JWT Stuff

  def auth(token)
    begin
      secret = ENV['JWT_SECRET']
      decoded_token = JWT.decode(token, secret, false)
      @user = decoded_token
      cards = @user[0]["http://tadl.org/patron-cards"]
      session[:cards] = cards
      session[:expires] = 1.hour.from_now.utc
      return cards
    rescue JWT::DecodeError
      session[:cards] = nil
      redirect_to "https://catalog.tadl.org/eg/opac/login"
    end
  end
end
