require 'rails_helper'

RSpec.describe Mutations::SaveListing, type: :graphql do
  let(:user) { create(:user) }
  let(:listing_input) do
    attributes_for(:listing).merge(
      {
        categoryId: create(:category).id,
        productTypeId: create(:product_type).id,
        manufacturerId: create(:manufacturer).id,
        setTypeId: create(:set_type).id,
        images: [],
      },
    )
  end

  let(:mutation) do
    '
      mutation saveListing($listing: ListingInput!, $player: PlayerInput!) {
        saveListing(listing: $listing, player: $player) {
          viewer {
            id
            availableListings: listings(status: available) {
              ...listing
            }
          }
          message
        }
      }
      fragment listing on Listing {
        title
        description
        price
        images {
          id
          url
        }
        player {
          name
        }
        offers {
          id
          price
        }
      }
    '
  end
  let(:expected) do
    {
      saveListing: {
        viewer: {
          id: user.id,
          availableListings: [
            {
              description: 'Listing Desc',
              images: [],
              offers: [],
              player: { name: 'Big Kahuna' },
              price: 1_234_500,
              title: 'Listing Title',
            },
          ],
        },
        message: 'Listing created!',
      },
    }
  end
  let(:variables) { { listing: listing_input, player: { name: 'Big Kahuna' } } }

  describe '#resolve' do
    it { expect_query_result(mutation, expected, variables: variables) }

    it 'creates new player' do
      expect { execute_query(mutation, variables: variables) }.to change(
        Player,
        :count,
      ).by(1)
    end
  end
end
