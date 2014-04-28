class Participant < ActiveRecord::Base
	has_many :awards
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
end
