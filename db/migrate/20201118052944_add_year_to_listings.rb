class AddYearToListings < ActiveRecord::Migration[6.1]
  def change
    add_column :listings, :year, :integer
  end
end
