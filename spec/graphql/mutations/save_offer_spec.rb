require 'rails_helper'

RSpec.describe Mutations::SaveOffer, type: :graphql do
  include StripeHelpers
  let(:user) { create(:user) }
  let(:cust) { create(:stripe_customer, user: user) }
  let(:listing) { create(:listing) }

  let(:mutation) do
    '
      mutation saveOffer($offer: OfferInput!) {
        saveOffer(offer: $offer) {
          paymentIntentId
        }
      }
    '
  end

  let(:expected) { { saveOffer: { paymentIntentId: 'pi_1HXX' } } }
  let(:variables) { { offer: { price: 12.34, listingId: listing.id } } }

  before do
    mock_stripe(:payment_intent, customer: cust.token, client_secret: 'pi_1HXX')
    create(:stripe_payment_method, stripe_customer: cust)
  end

  describe '#resolve' do
    it { expect_query_result(mutation, expected, variables: variables) }

    it 'saves new offer' do
      expect { execute_query(mutation, variables: variables) }.to change(
        Offer,
        :count,
      ).by(1)
    end

    it 'multiplies price by 100' do
      execute_query(mutation, variables: variables)
      expect(Offer.last.price).to eq(1234)
    end
  end
end
