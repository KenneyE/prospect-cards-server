class AddManufacturerToListings < ActiveRecord::Migration[6.0]
  def change
    add_reference :listings, :manufacturer, foreign_key: true
    Listing.find_each do |l|
      l.update_attribute(:manufacturer_id, Manufacturer.all.sample.id)
    end
    change_column_null :listings, :manufacturer_id, false
  end
end
