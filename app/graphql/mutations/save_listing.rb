class Mutations::SaveListing < Mutations::BaseMutation
  argument :listing, Inputs::ListingInput, required: true
  argument :player, Inputs::PlayerInput, required: true

  field :viewer, Types::User, null: false

  def resolve(listing:, player:)
    require_confirmation!
    l = _save_listing(listing, player)
    _save_images(l, listing[:images])
    l.save

    raise_errors(l)

    { viewer: current_user, message: 'Listing created!' }
  end

  private

  def _save_listing(listing, player)
    p = Player.find_or_create_by(name: player[:name].titleize)
    h = listing.to_h
    h[:price] = (h[:price] * 100).floor

    Listing.new(
      h.except(:images).merge(
        user_id: current_user.id, player: p,
      ),
    )
  end

  def _save_images(listing, images)
    # https://github.com/jetruby/apollo_upload_server-ruby/issues/10#issuecomment-406928478
    images.each do |img|
      listing.images.attach(
        io: img['document'].to_io, filename: img['document'].original_filename,
      )
    end
  end
end
