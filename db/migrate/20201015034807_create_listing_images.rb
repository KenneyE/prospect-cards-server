class CreateListingImages < ActiveRecord::Migration[6.1]
  def up
    create_table :listing_images do |t|
      t.references :listing, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end

  def down
    drop_table :listing_images
  end
end
