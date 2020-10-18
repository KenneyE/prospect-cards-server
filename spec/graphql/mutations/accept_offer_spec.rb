require 'rails_helper'

RSpec.describe Mutations::AcceptOffer, type: :graphql do
  include StripeHelpers

  let(:user) { create(:user) }
  let(:listing) { create(:listing, user: user) }
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

  before { mock_stripe(:payment_intent) }

  describe '#resolve' do
    it { expect_query_result(mutation, expected, variables: variables) }

    it 'updates listing status' do
      expect { execute_query(mutation, variables: variables) }.to change {
        listing.reload.status
      }.from('available').to('sold')
    end

    context 'when listing is pending' do
      before { listing.update(status: :pending_sale) }

      it 'raises error' do
        expect_error(
          mutation,
          'Cannot accept already pending offer',
          variables: variables,
        )
      end
    end
  end
end
