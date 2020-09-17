class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  # Minimum bid of $1
  validates :price,
            numericality: {
              greater_than_or_equal_to: 100, message: 'must be at least $1.00'
            }
end
