# Controller for accepting Stripe webhooks
class StripeWebhooksController < ApplicationController
  extend Memoist

  def event
    @stripe_event = _verified_event

    _update_local_record

    render(json: {}, status: :ok)
  rescue Stripe::SignatureVerificationError, Stripe::StripeError => e
    render(json: { error: e.message }, status: :bad_request)
  end

  def _verified_event
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    Stripe::Webhook.construct_event(
      payload,
      sig_header,
      Rails.application.credentials.dig(:stripe, :webhook_signing_secret),
    )
  end
  memoize :_verified_event

  def _event_class
    @_event_class ||=
      StripeWebhookService.class_from_event_type(@stripe_event.type)
  end
  memoize :_event_class

  def _stripe_object
    _verified_event.data.object
  end

  def _update_local_record
    return if _event_class.nil?

    theirs = _stripe_object

    ours = _event_class.find_or_initialize_by({ token: theirs.id })

    ours.update_from_stripe(theirs)
  end
end
