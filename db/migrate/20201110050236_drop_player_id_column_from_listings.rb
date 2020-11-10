class DropPlayerIdColumnFromListings < ActiveRecord::Migration[6.1]
  def change
    Listing::TAG_TYPES.each do |tag|
      remove_column :listings, "#{tag}_id"
    end
  end
end
