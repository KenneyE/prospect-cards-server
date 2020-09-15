class StripeAccount < StripeModel
  WEBHOOK_EVENTS = %w[account.updated].freeze

  belongs_to :user,
             foreign_key: :token,
             primary_key: :stripe_account_id,
             inverse_of: :stripe_account

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
    update_from_stripe(acct)
  end

  def params_from_stripe_object(account)
    {
      token: account.id,
      charges_enabled: account.charges_enabled,
      details_submitted: account.details_submitted
    }
  end

  private

  def return_url
    "#{
      Rails.application.credentials.dig(:app, :client_url)
    }/account/verification"
  end

  def refresh_url
    "#{Rails.application.credentials.dig(:app, :client_url)}/account/sell"
  end
end
