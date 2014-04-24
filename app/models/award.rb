class Award < ActiveRecord::Base
	belongs_to :participant
	belongs_to :experience
end
