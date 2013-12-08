class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :gui_name
      t.string :file_name
      t.string :url_slug
      t.string :tags

      t.timestamps
    end
  end
end
