class SendCSVJob
	include SuckerPunch::Job

	def perform(user_email, data, csv_description)
      puts "hello"
  		participant_csv = CSV.generate do |csv|
        	csv << ['First Name', 'Last Name', 'Age', 'Club', 'Home Library', 'Library Card #', 'School', 'Experience Count', 'Phone', 'Email']
        	data.each do |p|
            	csv << [p.first_name, p.last_name, p.age, p.club, p.home_library, p.library_card, p.school, p.awards.count, p.phone, p.email,]
        	end
        end
    	CsvMailer.csv_email(user_email, participant_csv, csv_description).deliver
  	end

end