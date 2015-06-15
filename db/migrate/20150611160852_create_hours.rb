class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.string :amount
      t.string :week
      t.string :participant_id

      t.timestamps
    end
  end
end
