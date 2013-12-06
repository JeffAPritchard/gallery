class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.string :icon
      t.string :url
      t.integer :category_id

      t.timestamps
    end
  end
end
