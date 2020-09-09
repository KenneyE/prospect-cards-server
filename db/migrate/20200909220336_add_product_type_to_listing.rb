class AddProductTypeToListing < ActiveRecord::Migration[6.0]
  def change
    add_reference :listings, :product_type, foreign_key: true
    Listing.find_each do |l|
      l.update_attribute(:product_type_id, ProductType.all.sample.id)
    end
    change_column_null :listings, :product_type_id, false
  end
end
