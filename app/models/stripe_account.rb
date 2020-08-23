class StripeAccount < ApplicationRecord
  has_one :user, foreign_key: :stripe_account_id, primary_key: :token

  def onboarding_link
    Stripe::AccountLink.create(
      {
        account: token,
        refresh_url: refresh_url,
        return_url: return_url,
        type: 'account_onboarding'
      }
    ).url
  end

  def refresh
    acct = Stripe::Account.retrieve(token)

    update(charges_enabled: acct.charges_enabled)
  end

  private

  def return_url
    "#{
      Rails.application.credentials.dig(:app, :client_url)
    }/account/verification"
  end

  def refresh_url
    "#{
    Rails.application.credentials.dig(:app, :client_url)
    }/account/sell"
  end
end
