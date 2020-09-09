class Types::User < Types::ActiveRecordObject
  field :listings, [Types::Listing], null: false
  field :stripe_account, Types::StripeAccount, null: false do
    argument :refresh, Boolean, required: false
  end
  def stripe_account(refresh: false)
    object.stripe_account.refresh if refresh

    object.stripe_account
  end

  field :has_active_subscription,
        Boolean,
        null: false, method: :has_active_subscription?

  field :payment_intent, String, null: false
  def payment_intent
    intent =
      Stripe::PaymentIntent.create(
        {
          customer: StripeCustomer.last.token,
          payment_method: 'card_1HKQLUIFW5W5DEYQlAItRjUz',
          amount: 10_000,
          currency: 'usd',
          transfer_group: '{ORDER10}'
        }
      )

    intent.client_secret
  end

  field :players, [Types::Player], null: false do
    argument :name, String, required: false
  end
  def players(name: nil)
    p = Player.all
    unless name.nil?
      p = p.where('LOWER(name) LIKE :name', name: "%#{name.downcase}%")
    end

    p.joins(:listings).group('players.id').order('COUNT(players.id) DESC')
  end

  field :available_memberships, [Types::Membership], null: false
  def available_memberships
    [
      { token: 'price_1HKXHGIFW5W5DEYQwbeHoEZi', price: 2000, term: 'month' },
      {
        token: 'price_1HKXHGIFW5W5DEYQmWW2aIvz', price: 10_500, term: '6 months'
      },
      { token: 'price_1HKXHGIFW5W5DEYQ4AWYr99h', price: 20_000, term: 'year' }
    ]
  end
end
