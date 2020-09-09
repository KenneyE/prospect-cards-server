class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.text :name, null: false

      t.timestamps
    end

    Category.create!(name: 'Basketball')
  end
end
