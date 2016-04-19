class SendTeenFinalCSVJob
	include SuckerPunch::Job

	def perform(user_email, data, csv_description)
      
  		participant_csv = CSV.generate do |csv|
        	csv << ['First Name', 'Last Name', 'Age', 'Club', 'Home Library', 'Library Card #', 'School', 'Experience Count', 'Email', 'total hours']
        	data.each do |p|
            	csv << [p.first_name, p.last_name, p.age, p.club, p.home_library, p.library_card, p.school, p.awards.count, p.email, p.total_hours]
        	end
        end
    	CsvMailer.csv_email(user_email, participant_csv, csv_description).deliver
  	end

end