class AddGradersToListings < ActiveRecord::Migration[6.0]
  def change
    add_reference :listings, :grader, foreign_key: true
    Listing.find_each do |l|
      l.update_attribute(:grader_id, Grader.all.sample.id)
    end
  end
end
