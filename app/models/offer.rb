class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :listing
  belongs_to :stripe_payment_intent,
             foreign_key: :payment_intent_id,
             primary_key: :token,
             inverse_of: :offer

  has_one :purchase, dependent: :destroy

  # Minimum bid of $1
  validates :price, numericality: { greater_than_or_equal_to: 500 }
  validate :_price_not_above_listing

  scope :unexpired, -> { where('offers.created_at >= ?', 24.hours.ago) }

  scope :confirmed,
        lambda {
          left_joins(:stripe_payment_intent).where(
            offers: { confirmed: true },
            stripe_payment_intents: {
              status: [
                nil,
                'processing',
                'requires_capture',
                'requires_confirmation',
                'requires_payment_method',
              ],
            },
          )
        }

  scope :open, -> { confirmed.unexpired }

  def seller
    listing.seller
  end

  def formatted_price
    Money.new(price).format
  end

  private

  def _price_not_above_listing
    return if price <= listing.price

    errors.add(:price, :above_listing_price)
  end
end
