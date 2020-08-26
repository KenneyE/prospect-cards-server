# typed: false
# Controller for accepting Stripe webhooks
class StripeWebhooksController < ApplicationController
  def event
    event = _verified_event

    case event.type
    when 'charge.succeeded'
      # Create a Transfer to a connected account (later):
      transfer =
        Stripe::Transfer.create(
          {
            amount: 7000,
            currency: 'usd',
            destination: StripeAccount.first.token,
            transfer_group: '{ORDER10}'
          }
        )

      # Create a second Transfer to another connected account (later):
      transfer =
        Stripe::Transfer.create(
          {
            amount: 2000,
            currency: 'usd',
            destination: StripeAccount.last.token,
            transfer_group: '{ORDER10}'
          }
        )

    end
    render json: {}, status: 200
  rescue Stripe::SignatureVerificationError, Stripe::StripeError => error
    # Use version with message only for debugging. Otherwise, stripe doesn't
    # care about the error that occurred so keep to ourselves.
    render json: { error: error.message }, status: 400
    # render json: {}, status: 400
  end


  def _verified_event
    # https://stripe.com/docs/webhooks/signatures#verify-official-libraries
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    Stripe::Webhook.construct_event(
      payload,
      sig_header,
      Rails.application.credentials.dig(:stripe, :webhook_signing_secret)
    )
  end
end
