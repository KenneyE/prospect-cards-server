require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { create(:user) }

  let(:stripe_customer) { create(:stripe_customer, user: user) }

  describe '#payment_method?' do
    context 'with a payment method' do
      before do
        create(:stripe_payment_method, stripe_customer: stripe_customer)
      end

      it 'is true' do
        expect(user).to be_payment_method
      end
    end
  end
end
