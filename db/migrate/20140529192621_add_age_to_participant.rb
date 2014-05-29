class AddAgeToParticipant < ActiveRecord::Migration
  def change
  	add_column :participants, :age, :integer
  end
end
