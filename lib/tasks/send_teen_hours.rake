desc "Send emails for weekly winners"
task :send_teen_hours =>  :environment do
	require 'tzinfo'
	require 'csv'
	
	def match_library(l)
		if l == 'Woodmere'
			return 'smorey@tadl.org, lsmith@tadl.org'
		elsif l == 'Kingsley'
			return 'smorey@tadl.org'
		elsif l == 'Interlochen'
			return 'smorey@tadl.org,rkelchak@tadl.org'
		elsif  l == 'East Bay'
			return 'smorey@tadl.org,jkelly@tadl.org,rflickinger@tadl.org '
		elsif l == 'Peninsula'
			return 'smorey@tadl.org,vshurly@tadl.org'
		elsif l == 'Fife Lake'
			return 'smorey@tadl.org,jkintner@tadl.org'
		end	
	end

	# Set week_number here
	week_number = 7


	Time.zone = 'Eastern Time (US & Canada)'
	report_dates = ['06/24/2015','07/01/2015','07/08/2015','07/15/2015','07/22/2015', '07/29/2015', '08/05/12', '08/12/2015']
	libraries = ['Woodmere']
	time_now = Time.now.strftime("%m/%d/%Y")
	if report_dates.include?(time_now)
		patrons = Participant.includes(:awards).where(inactive: false, club: "teen").order("id DESC")
		patrons_with_right_criteria = Array.new
		end_date = Time.strptime(time_now ,"%m/%d/%Y")
		start_date = end_date - 7.days
		puts start_date.to_s + ' - ' + end_date.to_s
		patrons.each do |p|
			if p.week(week_number) > 0
				puts p.first_name + p.week(week_number).to_s
				patrons_with_right_criteria = patrons_with_right_criteria.push(p)
			end
		end
		libraries.each do |l|
			patron_list = Array.new
			patrons_with_right_criteria.each do |p|
				if p.home_library == l 
					patron_list = patron_list.push(p)
				end
			end
			person_to_email = match_library(l) 
			description = 'report contains all teens at ' + l + ' who reported a hours in the last week.' 
			SendTeenHourCSVJob.new.perform(person_to_email, patron_list, description, week_number)
		end
	else
		puts "Now is not the time for emails"
	end
end