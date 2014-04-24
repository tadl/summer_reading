class Awards < ActiveRecord::Base
	belongs_to :particpant
	belongs_to :experience
end
