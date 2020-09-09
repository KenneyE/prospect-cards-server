class CreateProductTypes < ActiveRecord::Migration[6.0]
  TYPES = [
    'Box',
    'Case',
    'Coin',
    'Lot',
    'Pack',
    'Printing Plate',
    'Set',
    'Single',
    'Team Set',
    'Uncut Sheet',
    'Not Specified',
  ].freeze

  def change
    create_table :product_types do |t|
      t.text :name, null: false

      t.timestamps
    end

    ProductType.create!(TYPES.map { |type| { name: type }})
  end
end
