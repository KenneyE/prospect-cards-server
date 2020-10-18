require 'rails_helper'

RSpec.describe Mutations::AcceptOffer, type: :graphql do
  include StripeHelpers

  let(:user) { create(:user) }
  let(:listing) { create(:listing, user: user)}
  let(:offer) { create(:offer, listing: listing) }

  let(:mutation) do
    '
    mutation acceptOffer($offerId: Int!) {
      acceptOffer(offerId: $offerId) {
        message
      }
    }
    '
  end
  let(:expected) { { acceptOffer: { message: 'Offer accepted. Congrats!' } } }
  let(:variables) { { offerId: offer.id } }

  before do
    mock_stripe(:payment_intent)
  end

  describe '#resolve' do
    it do
      expect_query_result(mutation, expected, variables: variables)
    end
  end
end
