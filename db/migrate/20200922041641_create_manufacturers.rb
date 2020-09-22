class CreateManufacturers < ActiveRecord::Migration[6.0]
  TYPES = [
    'Panini',
    'Upper Deck',
    'Topps',
    'Other',
  ].freeze

  def change
    create_table :manufacturers do |t|
      t.text :name, null: false

      t.timestamps
    end

    Manufacturer.create!(TYPES.map { |type| { name: type }})
  end
end
