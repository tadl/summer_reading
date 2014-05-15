class AddImageUrlToExperience < ActiveRecord::Migration
  def change
  	add_column :experiences, :image_url, :string
  end
end
