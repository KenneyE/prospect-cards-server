class Mutations::SaveListing < Mutations::BaseMutation
  argument :listing, Inputs::ListingInput, required: true

  field :viewer, Types::User, null: false

  def resolve(listing:)
    require_confirmation!

    l = _save_listing(listing)
    raise_errors(l)

    _save_images(l, listing[:images])

    { viewer: current_user, message: 'Listing created!' }
  end

  private

  def _save_listing(listing)
    h = listing.to_h
    h[:price] = (h[:price] * 100).floor

    l = Listing.find_or_initialize_by(id: listing[:id])

    l.category_list = listing[:category]
    l.product_type_list = listing[:product_type]
    l.manufacturer_list = listing[:manufacturer]
    l.set_type_list = listing[:set_type]
    l.player_list = listing[:player]
    l.grader_list = listing[:grader]

    l.update(
      h.except(:images, *Listing::TAG_TYPES).merge(
        user_id: current_user.id,
      ),
    )
    l
  end

  def _save_images(listing, images)
    # https://github.com/jetruby/apollo_upload_server-ruby/issues/10#issuecomment-406928478
    images.each_with_index do |img, ind|
      new_img = listing.images.create(position: ind + 1)
      new_img.image.attach(
        io: img['document'].to_io, filename: img['document'].original_filename,
      )
    end
  end
end
