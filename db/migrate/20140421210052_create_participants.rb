class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :library_card
      t.string :email
      t.integer :zip_code
      t.string :home_library
      t.string :school
      t.string :grade
      t.integer :age
      t.string :club

      t.timestamps
    end
  end
end
