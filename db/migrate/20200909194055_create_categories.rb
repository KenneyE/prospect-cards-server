class CreateCategories < ActiveRecord::Migration[6.0]
  TYPES = [
    'Basketball',
    'Baseball',
    'Football',
    'Soccer',
    'Ice Hockey',
    'Not Specified',
  ].freeze

  def change
    create_table :categories do |t|
      t.text :name, null: false

      t.timestamps
    end

    Category.create!(TYPES.map { |type| { name: type }})
  end
end
