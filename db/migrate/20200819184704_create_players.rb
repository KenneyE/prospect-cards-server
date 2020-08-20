class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.text :name, null: false

      t.timestamps
    end
  end
end
