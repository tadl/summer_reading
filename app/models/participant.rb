class Participant < ActiveRecord::Base
	include PgSearch
	pg_search_scope :search_by_name, :against =>[:first_name, :last_name],  :using => { :tsearch => {:prefix => true}}
	pg_search_scope :search_by_card, :against =>[:library_card], :order_within_rank => "updated_at DESC"
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

	def age
		now = Time.now.utc.to_date
  		now.year - self.birth_date.year - ((now.month > self.birth_date.month || (now.month == self.birth_date.month && now.day >= self.birth_date.day)) ? 0 : 1)
	end

end
