require 'rails_helper'

RSpec.describe Mutations::ReportListing, type: :graphql do
  let(:user) { create(:user) }
  let(:listing) { create(:listing) }

  let(:mutation) do
    '
      mutation reportListing($listingId: Int!, $text: String!) {
        reportListing(listingId: $listingId, text: $text) {
          message
        }
      }
    '
  end
  let(:expected) do
    {
      reportListing: {
        message: 'Thanks for reporting! Our team will review immediately.',
      },
    }
  end
  let(:variables) { { listingId: listing.id, text: 'It offends me' } }

  describe '#resolve' do
    it { expect_query_result(mutation, expected, variables: variables) }

    it 'records report' do
      expect { execute_query(mutation, variables: variables) }.to change(
        ListingReport,
        :count,
      ).by(1)
    end

    context 'when unconfirmed' do
      let(:user) { create(:user, confirmed_at: nil) }

      it 'errors' do
        expect_error(
          mutation,
          'Please confirm your email address and try again.',
          variables: variables,
        )
      end
    end
  end
end
