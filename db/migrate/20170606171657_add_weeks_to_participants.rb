class AddWeeksToParticipants < ActiveRecord::Migration
  def change
  	add_column :participants, :week_1, :boolean, :default => false
  	add_column :participants, :week_2, :boolean, :default => false
  	add_column :participants, :week_3, :boolean, :default => false
  	add_column :participants, :week_4, :boolean, :default => false
  	add_column :participants, :week_5, :boolean, :default => false
  	add_column :participants, :week_6, :boolean, :default => false
  end
end
