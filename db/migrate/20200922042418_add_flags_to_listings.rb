class AddFlagsToListings < ActiveRecord::Migration[6.0]
  def change
    add_column :listings, :rookie, :boolean, null: false, default: false
  end
end
