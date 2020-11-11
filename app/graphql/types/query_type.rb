class Types::QueryType < Types::BaseObject
  field :auth, Boolean, null: false
  def auth
    context[:current_user].present?
  end

  # Same as viewer but used in queries where the viewer may be null
  field :maybe_viewer, Types::User, null: true
  def maybe_viewer
    context[:current_user]
  end

  field :viewer, Types::User, null: false do
    argument :token, String, required: false
  end
  def viewer(token: nil)
    if token.present?
      begin
        unescaped = CGI.unescape(token)
        user_id =
          Rails.application.message_verifier(:email_preferences).verify(
            unescaped,
          )
        User.find(user_id)
      rescue ActiveSupport::MessageVerifier::InvalidSignature => err
        raise(Errors::AuthenticationError, 'Invalid token')
      end
    else
      context[:current_user]
    end
  end

  field :listing, Types::Listing, null: false do
    argument :id, Integer, required: true
  end
  def listing(id:)
    Listing.find(id)
  end


  field :listings, [Types::Listing], null: false do
    argument :listing_ids, [Integer], required: true
  end
  def listings(listing_ids:)
    Listing.where(id: listing_ids).limit(50)
  end

  field :categories, [Types::Category], null: false
  def categories
    Category.all
  end

  field :tags, [Types::Tag], null: false do
    argument :context, Enums::TagTypesEnum, required: true
    argument :name, String, required: false
  end
  def tags(context:, name: '')
    t =
      ActsAsTaggableOn::Tag.left_joins(:taggings).where(
        taggings: { context: context },
      ).where('LOWER(name) LIKE :name', name: "%#{name.downcase}%").group(
        'tags.id',
      ).order('COUNT(taggings.id) DESC')

    t.limit(5).as_json(only: [:id, :name])
  end

  field :product_types, [Types::ProductType], null: false
  def product_types
    ProductType.all
  end

  field :manufacturers, [Types::Manufacturer], null: false
  def manufacturers
    Manufacturer.all
  end

  field :set_types, [Types::SetType], null: false
  def set_types
    SetType.all
  end

  field :graders, [Types::Grader], null: false
  def graders
    Grader.all
  end

  field :stripe_setup_intent_id, String, null: false
  def stripe_setup_intent_id
    opts = {
      payment_method_types: %w[card], customer: viewer.stripe_customer_id
    }

    Stripe::SetupIntent.create(opts).client_secret
  end
end
