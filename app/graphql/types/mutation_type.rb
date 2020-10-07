class Types::MutationType < Types::BaseObject
  field :save_listing, mutation: Mutations::SaveListing

  field :save_offer, mutation: Mutations::SaveOffer
  field :temp_confirm_offer, mutation: Mutations::TempConfirmOffer
  field :accept_offer, mutation: Mutations::AcceptOffer

  field :track_interest, mutation: Mutations::TrackInterest
  field :save_profile_picture, mutation: Mutations::SaveProfilePicture
end
