class CreateAwards < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.text :notes
      t.belongs_to :participant
      t.belongs_to :experience
      t.timestamps
    end
  end
end
