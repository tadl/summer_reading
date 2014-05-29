class AddCompletedForBaby < ActiveRecord::Migration
  def change
  	add_column :participants, :baby_complete, :boolean, :default => false 
  end
end
