require 'rails_helper'

RSpec.describe Mutations::SaveListing, type: :graphql do
  let(:user) { create(:user) }
  let(:listing_input) do
      {
        title: 'Listing Title',
        description: 'Listing Desc',
        player: 'Big Kahuna',
        category: 'Baseball',
        productType: 'Box',
        manufacturer: 'Panini',
        setType: 'Something',
        price: 1_234_5,
        images: [],
      }
  end

  let(:mutation) do
    '
        mutation saveListing($listing: ListingInput!) {
          saveListing(listing: $listing) {
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
          status
          player
          isFavorited
          images {
            id
            url
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
              player: 'Big Kahuna',
              price: 1_234_500,
              title: 'Listing Title',
              isFavorited: false,
              status: 'available',
            },
          ],
        },
        message: 'Listing created!',
      },
    }
  end
  let(:variables) { { listing: listing_input } }

  describe '#resolve' do
    it { expect_query_result(mutation, expected, variables: variables) }
  end
end
