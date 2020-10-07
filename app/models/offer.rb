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
              greater_than_or_equal_to: 100, message: 'must be at least $1.00'
            }

  scope :open,
        lambda {
          joins(:stripe_payment_intent).where(
            offers: { temp_confirmed: true },
            stripe_payment_intents: {
              status: %w[processing requires_capture requires_confirmation],
            },
          )
        }
end
