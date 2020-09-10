class Types::QueryType < Types::BaseObject
  field :auth, Boolean, null: false
  def auth
    context[:current_user].present?
  end

  field :viewer, Types::User, null: false
  def viewer
    context[:current_user]
  end

  field :listing, Types::Listing, null: false do
    argument :id, Integer, required: true
    argument :track, Boolean, required: false
  end
  # TODO: Make tracking its own mutation.
  def listing(id:, track: false)
    listing = Listing.find(id)

    current_user.players << listing.player if track && current_user.present?

    listing
  end

  field :categories, [Types::Category], null: false
  def categories
    Category.all
  end

  field :product_types, [Types::ProductType], null: false
  def product_types
    ProductType.all
  end

  field :stripe_checkout_session_id, String, null: false do
    argument :price, String, required: false
  end
  def stripe_checkout_session_id(price: nil)
    opts = {
      payment_method_types: %w[card],
      mode: price.present? ? 'subscription' : 'setup',
      customer: viewer.stripe_customer_id,
      success_url: "#{client_url}/account/payment_added",
      cancel_url: "#{client_url}/account/add_payment"
    }

    opts[:line_items] = [{ price: price, quantity: 1 }] if price.present?

    Stripe::Checkout::Session.create(opts).id
  end
end
