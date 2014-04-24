class Participant < ActiveRecord::Base
	has_many :awards
	has_many :experiences, through: :awards
end
