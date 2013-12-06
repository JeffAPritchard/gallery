class AddBlurbToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :blurb, :string
  end
end
