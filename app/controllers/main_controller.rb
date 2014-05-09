class MainController < ApplicationController
  before_filter :shared_variables
  before_action :authenticate_user!, :except => [:index, :sign_up, :register]
  before_action :check_for_approved, :except => [:index, :sign_up, :register, :admin_manage, :change_admin_role] 
  respond_to :html, :json
  
  def shared_variables
    @teen_schools = ['Central High School', 'TBA Career Tech Center', 'Kitchi Minogining Tribal School', 'Northwest Michigan House of Hope','Pathfinder School','St. Elizabeth Ann Seton Middle School', 'St. Francis High School', 'Traverse City Christian School', 'Traverse Bay Mennonite School', 'Traverse City College Preparatory Academy','Traverse City High School','Traverse City Seventh-Day Advent','West Middle School','West Senior High','Forest Area Middle School','Forest Area High School', 'Kingsley Area Middle School', 'Kingsley Area High School', "St. Mary's of Hannah", 'Greenspire School', 'Woodland School', 'New Campus', 'Grand Traverse Academy', 'Other', 'Home School',]
    
    @teen_grades = [5,6,8,9,10,11,12, 'College', 'None']


    @youth_schools = ['Blair','Central Grade School','Central Tag','Cherry Knoll','Courtade Elementary','Eastern','Holy Angels','Immaculate Conception Elementary','Long Lake','Northwest Michigan House of Hope','Old Mission Peninsula','Pathfinder School','Silver Lake','St. Elizabeth Ann Seton Middle School','Oak Park', 'TBA SE Early Childhood','TCAPS Montessori Schoool',"The Children's House",'Traverse Bay Christian School', 'Traverse Bay Mennonite School', 'Traverse City Seventh-Day Advent', 'Traverse Heights Elementary School','Trinity Lutheran','West Middle School','Westwoods','Willow Hill','Woodland School','Fife Lake Elementary','Forest Area Middle School','Interlochen Elementary','Kingsley Area Elementary','Kingsley Area Middle School','Lake Ann Elementary',"St. Mary's of Hannah",'Grand Traverse Academy','Greenspire School', 'New Campus', 'Other', 'Home School',]

    @youth_grades = ['Pre-School','Kindergarten', 1, 2, 3, 4, 5,]

  end

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
      @schools = @youth_schools.sort
      @grades = @youth_grades
    elsif group == "teen"
      @group_name = "Teen"
      @group_variable = params[:group]
      @schools = @teen_schools.sort
      @grades = @teen_grades
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
    birth_date = CGI.unescapeHTML(params[:birth_date])
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
      p.birth_date = birth_date
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
