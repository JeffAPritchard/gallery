class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :css_class
      t.string :icon

      t.timestamps
    end
  end
end
