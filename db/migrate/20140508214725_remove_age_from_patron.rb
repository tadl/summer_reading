class RemoveAgeFromPatron < ActiveRecord::Migration
  def change
  	remove_column :participants, :age
  end
end
