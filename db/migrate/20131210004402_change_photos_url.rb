class ChangePhotosUrl < ActiveRecord::Migration
  def change
    remove_column :photos, :url_slug
    add_column :photos, :description, :text
    add_column :photos, :location, :string
    add_column :photos, :times_viewed, :integer
    add_column :photos, :times_savored, :integer
    add_column :photos, :times_shared, :integer
  end
end
