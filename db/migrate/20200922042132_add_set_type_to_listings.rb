class AddSetTypeToListings < ActiveRecord::Migration[6.0]
  def change
    add_reference :listings, :set_type, foreign_key: true
    Listing.find_each do |l|
      l.update_attribute(:set_type_id, SetType.all.sample.id)
    end
    change_column_null :listings, :set_type_id, false
  end
end
