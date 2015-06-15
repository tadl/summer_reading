class Participant < ActiveRecord::Base
	include PgSearch
	pg_search_scope :search_by_name, :against =>[:first_name, :last_name],  :using => { :tsearch => {:prefix => true}}
	pg_search_scope :search_by_card, :against =>[:library_card]
	has_many :awards
	has_many :hours
	has_many :experiences, through: :awards

	def unearned_experiences	
		earned_experience = Award.where(:participant_id => self.id)
		if earned_experience.size == 0
			unearned_experiences = Experience.order('name ASC').all
		else
			experience_array = []
			earned_experience.each do |e|
				experience_array.push(e.experience_id)
			end
			unearned_experiences = Experience.order('name ASC').where("id not in(?)", experience_array)
		end
	end

	def needs_to_win
		awards_earned = self.awards.count
		awards_needed = 6 - awards_earned
		if awards_needed <= 0 
			return 'won'
		else
			return	awards_needed
		end
	end

	def total_hours
		patron_hours = 0
		self.hours.each do |h|
			patron_hours = h.amount.to_i + patron_hours
		end
		return patron_hours
	end

	def week(week_number)
		patron_hours = 0
		requested_week = 'week ' + week_number.to_s
		self.hours.where(:week => requested_week).each do |h|
			patron_hours = h.amount.to_i + patron_hours
		end
		return patron_hours
	end
end
