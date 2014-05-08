class AddFeildsToPatrons < ActiveRecord::Migration
  def change
  	add_column :participants, :birth_date, :date, :default => '1/1/2011'
  	add_column	:participants, :got_reading_kit, :boolean, :default => 'false'
  	add_column	:participants, :got_final_prize, :boolean, :default => 'false'
  end
end
