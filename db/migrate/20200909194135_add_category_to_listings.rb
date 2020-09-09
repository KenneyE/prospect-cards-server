class AddCategoryToListings < ActiveRecord::Migration[6.0]
  def change
    add_reference :listings, :category, foreign_key: true
    Listing.find_each do |l|
      l.update_attribute(:category_id, Category.all.sample.id)
    end
    change_column_null :listings, :category_id, false
  end
end
