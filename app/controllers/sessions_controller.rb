class SessionsController < ApplicationController
  def create
  	auth = request.env["omniauth.auth"]
  	user = Admin.find_by_provider_and_uid(auth["provider"], auth["uid"]) || Admin.from_omniauth(auth)
  	if user.id
      session[:user_id] = user.id
  	  redirect_to root_url, :notice => "Signed in!"
    else 
      alert_msg = "You must be staff member at Traverse Area District Library and login with your staff email address to use this service."
      redirect_to :root, :flash => {:alert => alert_msg } 
    end  
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
