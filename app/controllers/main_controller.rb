class MainController < ApplicationController
  require 'uri'
  require 'csv'
  
  before_filter :shared_variables
  before_action :authenticate_user!, :except => [:index, :sign_up, :register]
  before_action :check_for_approved, :except => [:index, :sign_up, :register, :admin_manage, :change_admin_role] 
  respond_to :html, :json
  
  def shared_variables
    @teen_schools = ['Central High School', 'TBA Career Tech Center', 'East Middle School', 'Kitchi Minogining Tribal School', 'Northwest Michigan House of Hope','Pathfinder School','St. Elizabeth Ann Seton Middle School', 'St. Francis High School', 'Traverse City Christian School', 'Traverse Bay Mennonite School', 'Traverse City College Preparatory Academy','Traverse City High School','Traverse City Seventh-Day Advent','West Middle School','West Senior High','Forest Area Middle School','Forest Area High School', 'Kingsley Area Middle School', 'Kingsley Area High School', "St. Mary's of Hannah", 'Greenspire School', 'Woodland School', 'New Campus', 'Grand Traverse Academy', 'Other', 'Home School',]
    
    @teen_grades = [6, 7, 8,9,10,11,12, 'College', 'None']

    @youth_schools = ['Blair','Central Grade School','East Middle School','Central Tag','Cherry Knoll','Courtade Elementary','Eastern','Holy Angels','Immaculate Conception Elementary','Long Lake','Northwest Michigan House of Hope','Old Mission Peninsula','Pathfinder School','Silver Lake','St. Elizabeth Ann Seton Middle School','Oak Park', 'TBA SE Early Childhood','TCAPS Montessori Schoool',"The Children's House",'Traverse Bay Christian School', 'Traverse Bay Mennonite School', 'Traverse City Seventh-Day Advent', 'Traverse Heights Elementary School','Trinity Lutheran','West Middle School','Westwoods','Willow Hill','Woodland School','Fife Lake Elementary','Forest Area Middle School','Interlochen Elementary','Kingsley Area Elementary','Kingsley Area Middle School','Lake Ann Elementary',"St. Mary's of Hannah",'Grand Traverse Academy','Greenspire School', 'New Campus', 'Other', 'Home School',]

    @youth_grades = ['Pre-School','Kindergarten', 1, 2, 3, 4, 5, 6, 7]

    @libraries = ['Woodmere','Kingsley','Interlochen','East Bay','Peninsula','Fife Lake']
    
    @baby_ages = [*0..3]
    @youth_ages = [*4..12]
    @teen_ages = [*13..19]
    @adult_ages = [*18..105]

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
      @age = @baby_ages
    elsif group == "youth"
      @group_name = "Youth"
      @group_variable = params[:group]
      @schools = @youth_schools.sort
      @grades = @youth_grades
      @age = @youth_ages
    elsif group == "teen"
      @group_name = "Teen"
      @group_variable = params[:group]
      @schools = @teen_schools.sort
      @grades = @teen_grades
      @age = @teen_ages
    elsif group == "adult"
      @group_name = "Adult"
      @group_variable = params[:group]
      @age = @adult_ages
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
    library_card_raw = CGI.unescapeHTML(params[:library_card])
    got_kit = params[:got_kit]
    library_card_clean = _normalize_card(library_card_raw) rescue library_card_raw
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
      p.library_card = library_card_clean
      if current_user && got_kit == 'true'
        p.got_reading_kit = true
      end
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

  def edit_patron
    @patron = Participant.find(params[:id])
    @group_variable = @patron.club
    if @patron.club == "baby"
      @age = @baby_ages
    elsif @patron.club == "youth"
      @age = @youth_ages
      @schools = @youth_schools.sort
      @grades = @youth_grades
    elsif @patron.club == "teen"
      @age = @teen_ages
      @grades = @teen_grades
      @schools = @teen_schools.sort
    elsif  @patron.club == "adult"
      @age = @adult_ages
    end
  end

  def update_patron
    first_name = CGI.unescapeHTML(params[:first_name])
    last_name = CGI.unescapeHTML(params[:last_name])
    age = CGI.unescapeHTML(params[:age])
    grade = CGI.unescapeHTML(params[:grade])
    school = CGI.unescapeHTML(params[:school])
    zip_code = CGI.unescapeHTML(params[:zip_code])
    home_library = CGI.unescapeHTML(params[:home_library])
    email = CGI.unescapeHTML(params[:email])
    library_card_raw = CGI.unescapeHTML(params[:library_card])
    library_card_clean = _normalize_card(library_card_raw) rescue library_card_raw
    p = Participant.find(params[:id])
    p.first_name = first_name
    p.last_name = last_name
    p.age = age
    p.grade = grade
    p.school = school
    p.zip_code = zip_code
    p.home_library = home_library
    p.email = email
    p.library_card = library_card_clean
    p.save

    respond_with do |format|
      format.json { render :json =>{message: 'updated'}}
    end 


  end




  def patron_list

    home_library = params[:location].try(:titleize)
    library = params[:location]
    @winner = params[:winner]

    if params[:group]
      club = params[:group]
    else
      club = 'all'
    end

    if params[:location]
      library = params[:location]
    else
      library = 'all'
    end
 
    respond_with do |format|
      format.html {
        participants_query = patron_filter(params[:page], home_library, params[:group], params[:winner])
        @participants = participants_query[0]
        @club_filter = club
        @location_filter = library
        @participant_count = participants_query[1]
        @total_experience_count = participants_query[2]
      }
      format.csv { 
        participants_query = patron_filter(params[:page], home_library, params[:group], params[:winner], true)
        @participants = participants_query[0]
        participant_csv = CSV.generate do |csv|
          csv << ['First Name', 'Last Name', 'Age', 'Club', 'Home Library', 'Library Card #', 'School', 'Experience Count', 'Email']
          @participants.each do |p|
            csv << [p.first_name, p.last_name, p.age, p.club, p.home_library, p.library_card, p.school, p.awards.count, p.email,]
          end
        end
        send_data participant_csv 
      }
    end  
  end

  def patron_filter(page_number = 1, home_library = nil, club = nil, winner = nil, csv = nil)    
    if winner.present?
      adult_winners = Participant.joins(:awards).group("participants.id").having('count(participants.id) >= ?', 6) 
      adult_winner_ids = []
      adult_winners.each do |p|
        adult_winner_ids = adult_winner_ids.push(p.id)
      end
    end
    patrons = Participant.all.where(inactive: false).order("id DESC")
    patrons = patrons.all.where("id in (?) or baby_complete = ?", adult_winner_ids, true) if winner.present?
    patrons = patrons.where(home_library: home_library) if home_library.present?
    patrons = patrons.where(club: club) if club.present?
    patron_count = patrons.count
    expereience_count = 0
    patrons.each do |p|
      expereience_count = p.awards.count + expereience_count
    end
    unless csv.present?
      patrons = patrons.page(page_number)
    end
    return patrons, patron_count, expereience_count
  end

  def inactive_patrons
    @participants = Participant.where(inactive: true).all.order("id DESC").page(params[:page])
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

  def revoke_award
    a = Award.find(params[:id])
    a.delete
    respond_with do |format|
        format.json { render :json =>{message: "award revoked"}}
    end 
  end

  def mark_got_kit
    participant_id = params[:participant]
    got_kit = params[:got_kit]
    p = Participant.find(participant_id)
    p.update_attributes(:got_reading_kit => got_kit)
    p.save
    respond_with do |format|
      format.json { render :json =>{message: 'complete'}}
    end 
  end

  def mark_got_prize
    participant_id = params[:participant]
    got_prize = params[:got_prize]
    p = Participant.find(participant_id)
    p.update_attributes(:got_final_prize => got_prize)
    p.save
    respond_with do |format|
      format.json { render :json =>{message: 'complete'}}
    end 
  end

  def mark_baby_complete
    participant_id = params[:participant]
    baby_complete = params[:baby_complete]
    p = Participant.find(participant_id)
    p.update_attributes(:baby_complete => baby_complete)
    p.save
    respond_with do |format|
      format.json { render :json =>{message: 'complete'}}
    end 
  end 

  def mark_inactive
    participant_id = params[:participant]
    inactive_switch = params[:inactive]
    p = Participant.find(participant_id)
    if inactive_switch == 'true'
      p.update_attributes(:inactive => true)
    else
      p.update_attributes(:inactive => false)
    end  
    p.save
    respond_with do |format|
      format.json { render :json =>{message: 'complete'}}
    end 
  end

  def search_by_name
    @search = URI.unescape(params[:name])
    @participants = Participant.search_by_name(params[:name]).where.not(inactive: true).page params[:page]
  end

  def search_by_card
    # TODO: normalize card value before searching by passing through _normalize_card?
    @search = URI.unescape(params[:card])
    clean_card = _normalize_card(@search) rescue @search
    @participants = Participant.search_by_card(clean_card).where.not(inactive: true).page params[:page]
  end

  def _normalize_card(card_value)
    # It is entirely possible that this method belongs somewhere else,
    # with regard to where things "should" go in a Ruby on Rails app

    # accept a value as input which represents a library card number
    # since the value may be supplied by a barcode scanner, we should attempt to
    # normalize the value by lowercasing it, stripping trailing characters, etc

    # Strip any whitespace
    card_value.gsub!(/\s+/, '')

    # Lowercase entire value
    card_value.downcase!

    # Strip trailing digits if this looks like a scanned drivers license or ID
    if (card_value.length == 27 or card_value.length == 25)
      card_value = card_value[0,13].downcase
    else
      if (card_value.length == 23) # Older format State ID cards
        card_value = card_value[0,12].downcase
      end
    end
     return card_value
  end




end
