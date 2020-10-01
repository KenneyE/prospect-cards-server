# typed: ignore
# This allows us to test with Stripe Signature verification enabled.
# https://github.com/rebelidealist/stripe-ruby-mock/issues/467
module StripeHelpers
  def wh_secret
    Rails.application.credentials.dig(:stripe, :webhook_signing_secret)
  end

  def create_event(event_type, evt: {}, obj: {})
    Stripe::Event.construct_from(
      stripe_webhook_fixture(event_type, evt: evt, obj: obj),
    )
  end

  def event_signature(event_json)
    time = Time.current
    signature =
      Stripe::Webhook::Signature.compute_signature(
        time,
        event_json,
        wh_secret,
      )
    scheme = Stripe::Webhook::Signature::EXPECTED_SCHEME

    "t=#{time.to_i},#{scheme}=#{signature}"
  end

  def event_headers(event)
    {
      'Stripe-Signature' => event_signature(event.to_json),
      'ACCEPT' => 'application/json',
    }
  end

  # Requirements for use:
  # - A json file with name format 'spec/fixtures/stripe/<type>.json'
  #
  # @param type [Symbol] Type of request to mock (e.g. :charge, :customer)
  # @param overrides [Hash] Hash of attributes to override on the fixture.
  def mock_stripe(type, overrides = {})
    @stripe_mocks ||= {}
    @stripe_mocks[type] = overrides

    stub_request(:any, %r{api.stripe.com/v1/.*}).to_return(
      body: ->(req) { body_from_request(req) }, status: 200,
    )
  end

  def stripe_fixture(type, overrides = {})
    object_from_fixture("spec/fixtures/stripe/#{type}.json", overrides)
  end

  # `evt` allows overriding attributes on the root Event object,
  # while `obj` overrides keys on the event object, e.g. the Charge itself.
  def stripe_webhook_fixture(type, evt: {}, obj: {})
    object_from_fixture(
      "spec/fixtures/stripe_webhooks/#{type}.json",
      evt.deep_merge(data: { object: obj }),
    )
  end

  #              ,;;;,
  #             ;;;;;;;
  #          .-'`\, '/_
  #        .'   \ ("`(_) PRIVATE
  #       / `-,.'\ \_/
  #       \  \/\  `--`
  #        \  \ \
  #         / /| |
  #        /_/ |_|
  #       ( _\ ( _\

  private

  # Convert a JSON fixture file into a usable object with symbolized keys
  # and overridden attributes.
  def object_from_fixture(path, overrides)
    JSON.parse(File.open(path).read).deep_symbolize_keys.deep_merge(overrides)
  end

  # Use the path of the request to determine which fixture to use.
  # Raise an error if we haven't mocked a response for this type of request.
  def body_from_request(req)
    type = type_from_path(req.uri.path)

    if type.nil?
      raise StandardError,
            "Attempting to access un-mocked Stripe endpoint: #{req.uri.path}"
    end

    stripe_fixture(type, @stripe_mocks[type.to_sym]).to_json
  end

  def type_from_path(path)
    type_from_path_as_array(path.split('/'))
  end

  # Recurse through the path, popping from the end until it matches an available
  # response. Return nil if we've gone through the whole path without an
  # available response.
  def type_from_path_as_array(path)
    type = path.pop

    return nil if type.nil?
    return type.singularize if available_responses.include?(type)

    type_from_path_as_array(path)
  end

  # Get the available fixture-types based on the fixture filenames.
  # Mocked `:charge` will look for a `charge.json` file based on a request that
  # includes `charges` in its path.
  # We use singular, although the Stripe path is plural.
  def available_responses
    @available_responses ||=
      Dir['spec/fixtures/stripe/*.json'].map do |file|
        file.split('/').last.remove('.json').pluralize
      end
  end
end
