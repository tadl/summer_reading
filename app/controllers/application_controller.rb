class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :authenticate_user!
  helper_method :check_for_admin
  private
  def current_user
    @current_user ||= Admin.find(session[:user_id]) if session[:user_id]
  end
    
  def authenticate_user!
      if !current_user
        redirect_to root_url, :alert => 'You need to sign in for access to this page.'
      end
  end

  def check_for_admin
    super_users = ENV["super_users"].split(',')

    if super_users.include? @current_user.email
      return true
    end
  end

end
