class DropPlayersTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :categories
    drop_table :favorite_listings
    drop_table :graders
    drop_table :manufacturers
    drop_table :player_interests
    drop_table :players
    drop_table :product_types
    drop_table :set_types
  end
end
