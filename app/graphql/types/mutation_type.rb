class Types::MutationType < Types::BaseObject
  field :save_listing, mutation: Mutations::SaveListing
  field :save_offer, mutation: Mutations::SaveOffer
  field :track_interest, mutation: Mutations::TrackInterest
  field :save_profile_picture, mutation: Mutations::SaveProfilePicture
end
