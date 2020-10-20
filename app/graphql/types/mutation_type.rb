class Types::MutationType < Types::BaseObject
  field :save_listing, mutation: Mutations::SaveListing
  field :report_listing, mutation: Mutations::ReportListing

  field :save_offer, mutation: Mutations::SaveOffer
  field :temp_confirm_offer, mutation: Mutations::TempConfirmOffer
  field :accept_offer, mutation: Mutations::AcceptOffer

  field :mark_notices_read, mutation: Mutations::MarkNoticesRead
  field :track_interest, mutation: Mutations::TrackInterest
  field :save_profile_picture, mutation: Mutations::SaveProfilePicture
  field :save_email_preferences, mutation: Mutations::SaveEmailPreferences

  #  ADMIN ONLY
  field :accept_listing_reports,
        mutation: Mutations::Admin::AcceptListingReports
end
