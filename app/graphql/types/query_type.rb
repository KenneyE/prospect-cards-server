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
  end
  def listing(id:)
    Listing.find(id)
  end

  field :categories, [Types::Category], null: false
  def categories
    Category.all
  end

  field :product_types, [Types::ProductType], null: false
  def product_types
    ProductType.all
  end

  field :manufacturers, [Types::Manufacturer], null: false
  def manufacturers
    ProductType.all
  end

  field :set_types, [Types::SetType], null: false
  def set_types
    SetType.all
  end

  field :graders, [Types::Grader], null: false
  def graders
    Grader.all
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
      cancel_url: "#{client_url}/account/add_payment",
    }

    opts[:line_items] = [{ price: price, quantity: 1 }] if price.present?

    Stripe::Checkout::Session.create(opts).id
  end
end
