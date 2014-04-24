class Experience < ActiveRecord::Base
	has_many :awards
	has_many :participants, through: :awards
end
