class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :listing
  belongs_to :stripe_payment_intent,
             foreign_key: :payment_intent_id,
             primary_key: :token,
             inverse_of: :offer

  # Minimum bid of $1
  validates :price,
            numericality: {
              greater_than_or_equal_to: 500, message: 'must be at least $5.00'
            }

  scope :unexpired, -> { where('offers.created_at >= ?', 24.hours.ago) }

  scope :confirmed,
        lambda {
          joins(:stripe_payment_intent).where(
            offers: { temp_confirmed: true },
            stripe_payment_intents: {
              status: %w[processing requires_capture requires_confirmation],
            }
          )
        }

  scope :open, -> { confirmed.unexpired }
end
