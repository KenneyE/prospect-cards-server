class CreatePlayerInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :player_interests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
