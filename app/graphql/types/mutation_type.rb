class Types::MutationType < Types::BaseObject
  field :save_listing, mutation: Mutations::SaveListing
  field :track_interest, mutation: Mutations::TrackInterest
end
