# typed: false
# Controller for accepting Stripe webhooks
class StripeWebhooksController < ApplicationController
  def event
    @stripe_event = _verified_event

    _update_local_record

    render json: {}, status: 200
  rescue Stripe::SignatureVerificationError, Stripe::StripeError => error # care about the error that occurred so keep to ourselves. # Use version with message only for debugging. Otherwise, stripe doesn't
    render json: { error: error.message }, status: 400 # render json: {}, status: 400
  end

  def _processable_event?(event)
    StripeWebhookService.class_from_event_type(event.type).present?
  end

  def _verified_event
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    Stripe::Webhook.construct_event(
      payload,
      sig_header,
      Rails.application.credentials.dig(:stripe, :webhook_signing_secret)
    )
  end

  def _event_class
    @_event_class ||=
      StripeWebhookService.class_from_event_type(@stripe_event.type)
  end

  def _update_local_record
    return if _event_class.nil?

    theirs = _verified_event.data.object

    ours = _event_class.find_or_initialize_by({ token: theirs.id })

    ours.update_from_stripe(theirs)
  end # In case this is an event type that we don't handle currently.
end
