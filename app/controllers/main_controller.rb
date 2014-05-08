class MainController < ApplicationController
  before_action :authenticate_user!, :except => [:index, :sign_up, :register]
  before_action :check_for_approved, :except => [:index, :sign_up, :register, :admin_manage, :change_admin_role] 
  respond_to :html, :json
  
  def index
  end

  def admin_manage
  	@admins = Admin.where(:role => 'approved')
  	@unapproved_admins = Admin.where(:role => 'unapproved')
  end

  def change_admin_role
  	if check_for_admin
    	role = params[:role]
    	user_id = params[:id]
    	u = Admin.find(user_id)
    	u.role = role
    	u.save
      	@message = "done"
    else
      	@message = "no rights"
    end
    respond_with do |format|
      	format.json { render :json =>{message: @message}}
    end 
  end

  def sign_up
    group = params[:group]
    if group == "baby" 
      @group_name = "Baby"
      @group_variable = params[:group]
    elsif group == "youth"
      @group_name = "Youth"
      @group_variable = params[:group]
    elsif group == "teen"
      @group_name = "Teen"
      @group_variable = params[:group]
    elsif group == "adult"
      @group_name = "Adult"
      @group_variable = params[:group]
    else
      alert_msg = "Something went wrong! Please try again."
      redirect_to :root, :flash => {:alert => alert_msg }      
    end
  end

  def register
    first_name = CGI.unescapeHTML(params[:first_name])
    last_name = CGI.unescapeHTML(params[:last_name])
    age = CGI.unescapeHTML(params[:age])
    grade = CGI.unescapeHTML(params[:grade])
    school = CGI.unescapeHTML(params[:school])
    zip_code = CGI.unescapeHTML(params[:zip_code])
    home_library = CGI.unescapeHTML(params[:home_library])
    club = CGI.unescapeHTML(params[:club])
    email = CGI.unescapeHTML(params[:email])
    library_card = CGI.unescapeHTML(params[:library_card])
    # We can do additional sanitization here
    # If required feilds are missing or we see anything wrong we can set valid_values 
    # As we are checking for wrong things we can update the error_message so the client knows what is up
    valid_values = true
    error_message = 'We noticed the following problems:'

    if valid_values
      p = Participant.new
      p.first_name = first_name
      p.last_name = last_name
      p.age = age
      p.grade = grade
      p.school = school
      p.zip_code = zip_code
      p.home_library = home_library
      p.club = club
      p.email = email
      p.library_card = library_card 
      p.save
    end

    if valid_values
      respond_with do |format|
        format.json { render :json =>{message: "success"}}
      end 
    else
      respond_with do |format|
        format.json { render :json =>{message: error_message}}
      end 
    end
  end

  def patron_list
    participants_count = Participant.count
    @participants = Participant.all.order(:id).page params[:page]
  end

  def experience_list
    @experiences = Experience.all
  end

  def award_list
    @awards = Award.all
  end

  def award_patron
    participant = params[:participant]
    experience = params[:experience]
    if Award.where(:participant_id => participant, :experience_id => experience ).blank?
      a = Award.new
      a.participant_id = participant
      a.experience_id = experience
      a.notes = params[:notes]
      a.save
      message = "success"
    else
      message = "award was already granted"
    end
    
    respond_with do |format|
        format.json { render :json =>{message: message}}
    end 
    
  end

  def search_by_name
    @search = URI.unescape(params[:name])
    @participants = Participant.search_by_name(params[:name]).page params[:page]
  end

  def search_by_card
    # Here is where we should apply Jeff's magic formula for MI driver license
    @search = URI.unescape(params[:card])
    get_all_participants = Participant.search_by_card(params[:card]).page params[:page]
  end

end
