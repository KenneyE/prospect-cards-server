require 'rails_helper'

RSpec.describe 'StripeWebhooks', type: :request do
  include StripeHelpers

  before do
    mock_stripe(:customer)
    mock_stripe(:account)

    create(:user, stripe_customer_id: 'cus_00000000000000')
  end

  describe 'success' do
    let(:event) do
      create_event('customer.created')
    end

    it 'does not create a stripe event' do
      post stripe_webhooks_url,
           params: event.to_json, headers: event_headers(event)

      expect(StripeCustomer.count).to eq 1
      expect(response.status).to eq 200
    end
  end
end
