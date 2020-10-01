class Types::User < Types::ActiveRecordObject
  field :email, String, null: false
  field :profile_picture_url, String, null: false

  field :listings, [Types::Listing], null: false do
    argument :status, Enums::ListingStatusEnum, required: false
  end
  def listings(status: nil)
    user_listings = object.listings

    return user_listings if status.nil?

    user_listings.where(status: Listing.statuses[status])
  end

  field :stripe_account, Types::StripeAccount, null: false do
    argument :refresh, Boolean, required: false
  end
  def stripe_account(refresh: false)
    object.stripe_account.refresh if refresh

    object.stripe_account
  end

  field :has_active_subscription,
        Boolean,
        null: false, method: :active_subscription?
  field :has_payment_method,
        Boolean,
        null: false, method: :payment_method?

  field :players, [Types::Player], null: false do
    argument :name, String, required: false
  end
  def players(name: nil)
    p = Player.all
    p = p.where('LOWER(name) LIKE :name', name: "%#{name.downcase}%") unless name.nil?

    p.joins(:listings).group('players.id').order('COUNT(players.id) DESC')
  end

  field :available_memberships, [Types::Membership], null: false
  def available_memberships
    [
      { token: 'price_1HKXHGIFW5W5DEYQwbeHoEZi', price: 2000, term: 'month' },
      {
        token: 'price_1HKXHGIFW5W5DEYQmWW2aIvz', price: 10_500, term: '6 months'
      },
      { token: 'price_1HKXHGIFW5W5DEYQ4AWYr99h', price: 20_000, term: 'year' },
    ]
  end
end
