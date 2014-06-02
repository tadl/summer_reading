class AddInactiveAndVerifyInfoToParticipants < ActiveRecord::Migration
  def change
  	add_column :participants, :verify_info, :boolean, :default => false
  	add_column :participants, :inactive, :boolean, :default => false
  end
end
