class AddPlayerToListings < ActiveRecord::Migration[6.0]
  def change
    add_reference :listings,
                  :player,
                  null: false, foreign_key: true, index: true
  end
end
