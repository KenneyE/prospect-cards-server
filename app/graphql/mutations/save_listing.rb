# typed: true
class Mutations::SaveListing < Mutations::BaseMutation
  argument :listing, Inputs::ListingInput, required: true
  argument :player, Inputs::PlayerInput, required: true

  field :viewer, Types::User, null: false

  def resolve(listing:, player:)
    imgs = listing[:images]

    p = Player.find_or_create_by(name: player[:name])
    l =
      Listing.new(
        listing.to_h.except(:images).merge(
          price: 1200, user: User.first, player: p
        )
      )

    # https://github.com/jetruby/apollo_upload_server-ruby/issues/10#issuecomment-406928478
    imgs.each do |img|
      l.images.attach(
        io: img['document'].to_io, filename: img['document'].original_filename
      )
    end

    l.save

    raise_errors(l)

    { viewer: current_user, message: 'Listing created!' }
  end
end
