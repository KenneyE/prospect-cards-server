# typed: true
# Responsible for miscellaneous Stripe Webhook-related actions that don't belong
# in a controller or model
class StripeWebhookService
  STRIPE_CLASSES = [
    StripeSubscription,
    StripeCustomer,
    StripePaymentIntent,
  ].freeze

  def self.class_from_event_type(event_type)
    STRIPE_CLASSES.find { |klass| klass::WEBHOOK_EVENTS.include?(event_type) }
  end
end
