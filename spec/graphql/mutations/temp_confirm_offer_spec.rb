require 'rails_helper'

RSpec.describe Mutations::TempConfirmOffer, type: :graphql do
  let(:user) { create(:user) }
  let(:offer) { create(:offer, user: user) }

  let(:mutation) do
    '
      mutation tempConfirmOffer($offerId: Int!) {
        tempConfirmOffer(offerId: $offerId) {
          viewer {
            id
            offers {
              ...offer
            }
          }
        }
      }
      fragment offer on Offer {
        id
        price
        listing {
          id
          title
          images {
            id
            url
          }
        }
      }
    '
  end

  let(:expected) do
    { tempConfirmOffer: { viewer: { id: user.id, offers: [] } } }
  end
  let(:variables) { { offerId: offer.id } }

  describe '#resolve' do
    it { expect_query_result(mutation, expected, variables: variables) }

    it 'sets offer as temp confirmed' do
      execute_query(mutation, variables: variables)
      expect(offer.reload).to be_temp_confirmed
    end
  end
end
