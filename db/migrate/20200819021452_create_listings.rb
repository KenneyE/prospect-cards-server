class CreateListings < ActiveRecord::Migration[6.0]
  def change
    create_table :listings do |t|
      t.text :title, null: false
      t.text :description, null: false
      t.references :user, null: false, foreign_key: true, index: true
      t.integer :price, null: false

      t.timestamps
    end
  end
end
