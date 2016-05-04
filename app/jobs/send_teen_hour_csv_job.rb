class SendTeenHourCSVJob
	include SuckerPunch::Job

	def perform(user_email, data, csv_description, week_number)
    week_number_description = 'Hour for Week Number ' + week_number.to_s
      
  		participant_csv = CSV.generate do |csv|
        	csv << ['First Name', 'Last Name', 'Age', 'Club', 'Home Library', 'Library Card #', 'School', 'Experience Count', 'Phone', 'Email', week_number_description, 'total hours']
        	data.each do |p|
            	csv << [p.first_name, p.last_name, p.age, p.club, p.home_library, p.library_card, p.school, p.awards.count, p.phone, p.email, p.week(week_number), p.total_hours]
        	end
        end
    	CsvMailer.csv_email(user_email, participant_csv, csv_description).deliver
  	end

end