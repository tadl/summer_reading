class MainController < ApplicationController
  include Webhookable
  require 'uri'
  require 'csv'
  require 'mechanize'
  require 'json'

  before_filter :shared_variables
  before_action :authenticate_user!, :except => [:index, :lookup, :sign_up, :register, :self_reward_form, :self_record_hours, :self_record_hours_refresh, :self_award_patron, :check_patron, :closing]
  before_action :check_for_approved, :except => [:index, :sign_up, :register, :lookup, :admin_manage, :self_record_hours, :self_record_hours_refresh, :change_admin_role, :self_reward_form, :self_award_patron, :check_patron, :closing] 
  before_action :block_non_tadl_user!, :only => [:edit_patron, :patron_list_export]
  skip_before_filter :verify_authenticity_token, :only => [:lookup, :sign_up, :self_record_hours_refresh, :self_record_hours, :register, :self_reward_form, :self_award_patron, :check_patron, :closing] 
  respond_to :html, :json, :js
  
  def shared_variables
    @teen_schools = ['Central High School', 'TBA Career Tech Center', 'East Middle School', 'Kitchi Minogining Tribal School', 'Northwest Michigan House of Hope','Pathfinder School','St. Elizabeth Ann Seton Middle School', 'St. Francis High School', 'Traverse City Christian School', 'Traverse Bay Mennonite School', 'Traverse City College Preparatory Academy','Traverse City High School','Traverse City Seventh-Day Advent','West Middle School','West Senior High','Forest Area Middle School','Forest Area High School', 'Kingsley Area Middle School', 'Kingsley Area High School', "St. Mary's of Hannah", 'Greenspire School', 'Woodland School', 'New Campus', 'Grand Traverse Academy', 'Other', 'Home School', 'Buckley Comm. Schools', 'Traverse City Christian School',]
    
    @teen_grades = [6, 7, 8,9,10,11,12, 'College', 'None']

    @youth_schools = ['Blair','Central Grade School','East Middle School','International School at Bertha Vos','Cherry Knoll','Courtade Elementary','Eastern','Holy Angels','Immaculate Conception Elementary','Long Lake','Northwest Michigan House of Hope','Old Mission Peninsula','Pathfinder School','Silver Lake','St. Elizabeth Ann Seton Middle School','Oak Park', 'TBA SE Early Childhood','TCAPS Montessori School',"The Children's House",'Traverse Bay Christian School', 'Traverse Bay Mennonite School', 'Traverse City Seventh-Day Advent', 'Traverse Heights Elementary School','Trinity Lutheran','West Middle School','Westwoods','Willow Hill','Woodland School','Forest Area Elementary','Forest Area Middle School','Interlochen Elementary','Kingsley Area Elementary','Kingsley Area Middle School','Lake Ann Elementary',"St. Mary's of Hannah",'Grand Traverse Academy','Greenspire School', 'New Campus', 'Other', 'Home School', 'Buckley Comm. Schools', 'Traverse City Christian School',]

    @youth_grades = ['Pre-School','Kindergarten', 1, 2, 3, 4, 5, 6, 7]

    @libraries = ['Woodmere','Kingsley','Interlochen','East Bay','Peninsula','Fife Lake']
    @clubs = ['baby', 'youth', 'teen', 'adult']
    @all_ages = [*0..105]
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
    Time.zone = 'Eastern Time (US & Canada)'
    @today = Time.now.strftime("%m/%d/%Y")
    @patron = Participant.find(params[:id])
    @group_variable = @patron.club
    @age = @all_ages
    if @patron.club == "baby"
    elsif @patron.club == "youth"
      @schools = @youth_schools.sort
      @grades = @youth_grades
    elsif @patron.club == "teen"
      @grades = @teen_grades
      @schools = @teen_schools.sort
    elsif  @patron.club == "adult"
    end
  end

  def update_patron
    first_name = CGI.unescapeHTML(params[:first_name])
    last_name = CGI.unescapeHTML(params[:last_name])
    age = CGI.unescapeHTML(params[:age])
    if params[:grade] && params[:school]
      grade = CGI.unescapeHTML(params[:grade])
      school = CGI.unescapeHTML(params[:school])
    end
    zip_code = CGI.unescapeHTML(params[:zip_code])
    home_library = CGI.unescapeHTML(params[:home_library])
    email = CGI.unescapeHTML(params[:email])
    club = CGI.unescapeHTML(params[:club])
    library_card_raw = CGI.unescapeHTML(params[:library_card])
    library_card_clean = _normalize_card(library_card_raw) rescue library_card_raw
    p = Participant.find(params[:id])
    p.first_name = first_name
    p.last_name = last_name
    p.age = age
    if grade && school
      p.grade = grade
      p.school = school
    end
    p.zip_code = zip_code
    p.home_library = home_library
    p.email = email
    p.club = club
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
    end  
  end

  def patron_list_export
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

    if params[:winner] == 'yes'
      winners = ' who are eligible for final prize '
    else
      winners = ''
    end

    csv_description = 'CSV contains users' + winners + ' at location: ' + library + ' in club: ' + club
    participants_query = patron_filter(params[:page], home_library, params[:group], params[:winner], true)
    @participants = participants_query[0]
    @user_email = current_user.email
    SendCSVJob.new.async.perform(@user_email, @participants, csv_description)
    respond_with do |format|
      format.json { render :json =>{message: 'complete'}}
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
    patrons = Participant.includes(:awards).where(inactive: false).order("id DESC")
    patrons = patrons.where("id in (?) or baby_complete = ?", adult_winner_ids, true) if winner.present?
    patrons = patrons.where(home_library: home_library) if home_library.present?
    patrons = patrons.where(club: club) if club.present?
    patron_count = patrons.count
    patron_ids = []
    patrons.each do |p|
      patron_ids = patron_ids.push(p.id)
    end
     experience_count = Award.where("participant_id in (?)", patron_ids).count
    
    unless csv.present?
      patrons = patrons.page(page_number)
    end
    return patrons, patron_count, experience_count
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

  def self_award_patron
    if session[:expires] > Time.now.utc
      session[:expires] = 1.hour.from_now.utc
      cards = session[:cards].split(',') rescue []
    end
    if cards.include?(params[:card])
      if Award.where(:participant_id => params[:participant], :experience_id => params[:experience] ).blank?
        a = Award.new
        a.participant_id = params[:participant]
        a.experience_id = params[:experience]
        a.did = params[:notes]
        a.read = params[:read]
        a.needs_prize = true
        a.save
        message = "success"
      else
        message = "award was already granted"
      end
    else
        message = "you do not have access to this account"
    end
    respond_with do |format|
      format.json { render :json =>{message: message}}
    end
  end

  def self_record_hours
    if session[:expires] > Time.now.utc
      session[:expires] = 1.hour.from_now.utc
      cards = session[:cards].split(',') rescue []
    end
    week = 'week ' + params[:week].to_s
    if cards.include?(params[:card]) || check_for_approved()
      if Hour.where(:participant_id => params[:id], :week => week).blank?
        h = Hour.new
        h.participant_id = params[:id]
        h.week = week
        h.amount = params[:hours]
        h.save
        message = "success"
      else
        h = Hour.where(:participant_id => params[:id], :week => week).first
        h.amount = params[:hours]
        h.save
        message = "success"
      end
    else
        message = "you do not have access to this account"
    end
    respond_with do |format|
      format.json { render :json =>{message: message}}
    end
  end

  def self_record_hours_refresh
    patron = Participant.find(params[:id])
    Time.zone = 'Eastern Time (US & Canada)'
    @today = Time.now.strftime("%m/%d/%Y")
    render :partial => "self_hours", :locals => {:patron => patron}
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

  def lookup
    Time.zone = 'Eastern Time (US & Canada)'
    @today = Time.now.strftime("%m/%d/%Y")
    if session[:cards]
      if session[:expires] && session[:expires] < Time.now.utc
        session[:cards] = nil
        redirect_to "https://catalog.tadl.org/eg/opac/myopac/main"
      end 
      cards = session[:cards].split(',') rescue []
    elsif params[:token]
      cards = auth(params[:token]).split(',') rescue []
    else
      redirect_to "https://catalog.tadl.org/eg/opac/myopac/main"
    end
    if cards
      @participants = Participant.where(library_card: cards).where.not(inactive: true).all.order("id DESC")
    else
      @participants = nil
    end
  end

  def self_reward_form
    @patron = Participant.find(params[:patron])
    @experience = Experience.find(params[:experience])
    respond_to do |format|
        format.js
    end
  end

  def award_prize
    a = Award.find(params[:id])
    a.needs_prize = false
    a.save
    respond_with do |format|
        format.json { render :json =>{message: "prize granted"}}
    end 
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

  def closing
    message_type = params[:message]
    if params[:message] != '59' || params[:message] != '00'
      if message_type == '45' || message_type == '44' || message_type == '46' 
        filename = 'https://s3.amazonaws.com/tadl-public-audio/overhead/15.mp3'
      elsif message_type == '50' || message_type == '49' || message_type == '51'
        filename = 'https://s3.amazonaws.com/tadl-public-audio/overhead/10.mp3'
      elsif message_type == '55' || message_type == '56' || message_type == '54'
        filename = 'https://s3.amazonaws.com/tadl-public-audio/overhead/5.mp3'
      end
      response = Twilio::TwiML::Response.new do |r|
          r.Pause :length => '2'
          r.Play :digits => 'w44534'
          r.Pause :length => '2'
          r.Play :digits => 'w921'
          r.Pause :length => '1'
          r.Play  'https://s3.amazonaws.com/tadl-public-audio/overhead/chime.mp3'
          r.Play  filename
          r.Pause :length => '3'
        end
      render_twiml response
    elsif params[:message] == '59' || params[:message] == '00'
      filename = 'https://s3.amazonaws.com/tadl-public-audio/overhead/closed.mp3'
      response = Twilio::TwiML::Response.new do |r|
          r.Pause :length => '25'
          r.Play :digits => 'w44534'
          r.Pause :length => '25'
          r.Play :digits => 'w921'
          r.Pause :length => '1'
          r.Play  'https://s3.amazonaws.com/tadl-public-audio/overhead/chime.mp3'
          r.Play filename
          r.Pause :length => '3'
        end
      render_twiml response
    end
  end
end
