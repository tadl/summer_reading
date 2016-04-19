desc "Send emails for weekly winners"
task :send_final_teen =>  :environment do
	require 'tzinfo'
	require 'csv'
	
	description = "Final report for Woodmere teens"
	patrons = Participant.includes(:awards).where(inactive: false, club: "teen", home_library: "Woodmere").order("id DESC")
	SendTeenFinalCSVJob.new.perform('smorey@tadl.org, lsmith@tadl.org', patrons, description)
end