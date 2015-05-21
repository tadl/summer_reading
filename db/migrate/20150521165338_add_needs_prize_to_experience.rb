class AddNeedsPrizeToExperience < ActiveRecord::Migration
  def change
  	add_column :awards, :needs_prize, :boolean, :default => false
  end
end
