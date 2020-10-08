class CreateListingReports < ActiveRecord::Migration[6.1]
  def change
    create_table :listing_reports do |t|
      t.references :listing, null: false, foreign_key: true
      t.text :text, null: false
      t.datetime :reviewed_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
