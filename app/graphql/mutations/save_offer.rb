class Mutations::SaveOffer < Mutations::BaseMutation
  argument :offer, Inputs::OfferInput, required: true

  field :payment_intent_id, String, null: false
  def resolve(offer:)
    listing = Listing.find(offer[:listing_id])
    price = offer[:price] * 100


    payment_intent = Stripe::PaymentIntent.create(
      {
        customer: current_user.stripe_customer_id,
        amount: price,
        currency: 'usd',
        off_session: true,
        # setup_future_usage: 'off_session',
        confirm: true,
        application_fee_amount: (price * 0.05).to_i,
        transfer_data: {
          destination: listing.user.stripe_account_id,
        },
      },
    )

    new_offer = current_user.offers.create(
      price: offer[:price] * 100,
      listing_id: offer[:listing_id],
      payment_intent_id: payment_intent.id,
    )

    raise_errors(new_offer)

    { payment_intent_id: payment_intent.id }
  end
end
