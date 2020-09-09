class AddCategoryToListings < ActiveRecord::Migration[6.0]
  def change
    add_reference :listings, :category, foreign_key: true, using: Category.first.id
    Listing.update_all(category_id: Category.first.id)
    change_column_null :listings, :category_id, false
  end
end
