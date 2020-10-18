require 'rails_helper'

RSpec.describe User, type: :model do
  include StripeHelpers

  subject(:user) { create(:user) }

  describe '#payment_method?' do
    context 'with a payment method' do
      before do
        mock_stripe(:account)
        mock_stripe(:customer)

        create(:stripe_payment_method, customer: user.stripe_customer_id)
      end

      it 'is true' do
        expect(user).to be_payment_method
      end
    end
  end
end
