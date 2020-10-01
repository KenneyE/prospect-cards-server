class Mutations::SaveOffer < Mutations::BaseMutation
  argument :offer, Inputs::OfferInput, required: true

  field :payment_intent_id, String, null: false
  def resolve(offer:)
    listing = Listing.find(offer[:listing_id])
    price = offer[:price] * 100


    payment_intent = Stripe::PaymentIntent.create(
      {
        customer: current_user.stripe_customer_id,
        payment_method: current_user.stripe_payment_methods.first.token,
        amount: price,
        currency: 'usd',
        capture_method: 'manual',
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

    { payment_intent_id: payment_intent.client_secret }
  end
end
