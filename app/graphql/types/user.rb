class Types::User < Types::ActiveRecordObject
  field :email, String, null: false
  field :admin, Boolean, null: false

  field :full_name, String, null: true
  field :street1, String, null: true
  field :street2, String, null: true
  field :city, String, null: true
  field :state, String, null: true
  field :zip, String, null: true
  field :confirmed, Boolean, null: false, method: :confirmed?

  field :profile_picture_url, String, null: false
  field :unread_notices, [Types::Notice], null: false
  field :email_preferences, [Types::EmailPreference], null: false
  def email_preferences
    cats = EmailPreference.all.pluck(:category).uniq
    cats.map do |cat|
      EmailPreference.find_or_create_by({ category: cat, user_id: object.id })
    end
  end

  field :listings, [Types::Listing], null: false do
    argument :status, Enums::ListingStatusEnum, required: false
  end
  def listings(status: nil)
    user_listings = object.listings

    return user_listings if status.nil?

    user_listings.where(status: Listing.statuses[status])
  end

  field :offers, [Types::Offer], null: false do
    argument :status, Enums::ListingStatusEnum, required: false
  end
  def offers(status: nil)
    user_offers =
      object.offers.open.joins(:listing).where(listings: { status: :available })
        .order(created_at: :desc)

    return user_offers if status.nil?

    user_offers.joins(:listing).where(
      'listings.status': Listing.statuses[status],
    )
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
  field :has_payment_method, Boolean, null: false, method: :payment_method?
  field :payment_method, Types::StripePaymentMethod, null: true

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
