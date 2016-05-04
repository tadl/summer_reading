class AddPhoneToParticipants < ActiveRecord::Migration
  def change
  	  add_column :participants, :phone, :string
  end
end