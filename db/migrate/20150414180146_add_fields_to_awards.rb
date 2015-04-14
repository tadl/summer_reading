class AddFieldsToAwards < ActiveRecord::Migration
  def change
    add_column :awards, :read, :text
    add_column :awards, :did, :text
  end
end
