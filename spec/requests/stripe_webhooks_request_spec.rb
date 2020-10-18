require 'rails_helper'

RSpec.describe 'StripeWebhooks', type: :request do
  include StripeHelpers

  before do
    create(:user, stripe_customer_id: 'cus_00000000000000')
    create(:stripe_customer, token: 'cus_00000000000000')
  end

  describe '#customer.created' do
    let(:event) do
      create_event('customer.created')
    end

    it 'creates a customer' do
      post stripe_webhooks_url,
           params: event.to_json, headers: event_headers(event)

      expect(StripeCustomer.count).to eq 1
      expect(response.status).to eq 200
    end
  end

  describe '#payment_method.attached' do
    before do
      mock_stripe(:payment_method)
    end

    let(:event) do
      create_event('payment_method.attached')
    end

    it 'creates a payment_method' do
      post stripe_webhooks_url,
           params: event.to_json, headers: event_headers(event)

      expect(StripePaymentMethod.count).to eq 1
      expect(response.status).to eq 200
    end
  end
end
