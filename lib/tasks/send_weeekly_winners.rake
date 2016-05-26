desc "Send emails for weekly winners"
task :send_weekly_winners =>  :environment do
	require 'tzinfo'
	require 'csv'
	
	def match_library(l)
		if l == 'Woodmere'
			return 'smorey@tadl.org,bbush@tadl.org'
		elsif l == 'Kingsley'
			return 'smorey@tadl.org,mfraquelli@tadl.org'
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

	Time.zone = 'Eastern Time (US & Canada)'
	report_dates = ['06/27/2016','07/04/2016','07/11/2016','07/18/2016','07/25/2016', '08/01/2016']
	libraries = ['Woodmere','Kingsley','Interlochen','East Bay','Peninsula','Fife Lake']
	time_now = Time.now.strftime("%m/%d/%Y")
	if report_dates.include?(time_now)
		patrons = Participant.includes(:awards).where(inactive: false, club: "adult").order("id DESC")
		patrons_with_right_criteria = Array.new
		end_date = Time.strptime(time_now ,"%m/%d/%Y")
		start_date = end_date - 7.days
		puts start_date.to_s + ' - ' + end_date.to_s
		patrons.each do |p|
			p.awards.each do |a|
				check_date = a.created_at.in_time_zone
				if check_date >= start_date && check_date <= end_date
					puts p.first_name + ' - ' +a.experience.name + ' - ' + a.created_at.in_time_zone('Eastern Time (US & Canada)').to_s
					patrons_with_right_criteria = patrons_with_right_criteria.push(p)
					break
				end
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
			description = 'report contains all adults at ' + l + ' who reported an experiences in the last week.' 
			SendCSVJob.new.perform(person_to_email, patron_list, description )
		end
	else
		puts "Now is not the time for emails"
	end
end