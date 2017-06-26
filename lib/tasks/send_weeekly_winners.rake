desc "Send emails for weekly winners"
task :send_weekly_winners =>  :environment do
	require 'tzinfo'
	require 'csv'
	
	def match_library(l)
		if l == 'Woodmere'
			return 'smorey@tadl.org,bbush@tadl.org,lsmith@tadl.org,aschuck@tadl.org'
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


	libraries = ['Woodmere','Kingsley','Interlochen','East Bay','Peninsula','Fife Lake']

	patrons = Participant.includes(:awards).where(inactive: false, club: "adult").order("id DESC")
	patrons_with_right_criteria = Array.new
	patrons.each do |p|
		if p.week_1 == true
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
		description = 'report contains all patrons at '  + l + ' who reported in the last week.' 
		SendCSVJob.new.perform(person_to_email, patron_list, description )
	end
end