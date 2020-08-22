class StripeAccount < ApplicationRecord
  has_one :user, foreign_key: :stripe_account_id, primary_key: :token

  def onboarding_link
    Stripe::AccountLink.create(
      {
        account: token,
        refresh_url: 'https://example.com/reauth',
        return_url: 'https://example.com/return',
        type: 'account_onboarding'
      }
    ).url
  end
end
