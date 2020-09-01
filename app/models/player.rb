class Player < ApplicationRecord
  has_many :listings, dependent: :destroy

  # Used for indexing in `listing.rb`
  def name_as_keyword
    name
  end
end
