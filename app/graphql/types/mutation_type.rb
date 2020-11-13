class Types::MutationType < Types::BaseObject
  field :save_listing, mutation: Mutations::SaveListing
  field :report_listing, mutation: Mutations::ReportListing

  field :save_offer, mutation: Mutations::SaveOffer
  field :confirm_offer, mutation: Mutations::ConfirmOffer
  field :accept_offer, mutation: Mutations::AcceptOffer

  field :sync_payment, mutation: Mutations::SyncPayment

  field :mark_notices_read, mutation: Mutations::MarkNoticesRead
  field :track_interest, mutation: Mutations::TrackInterest
  field :toggle_favorite, mutation: Mutations::ToggleFavorite
  field :save_profile_picture, mutation: Mutations::SaveProfilePicture
  field :save_profile, mutation: Mutations::SaveProfile
  field :save_email_preferences, mutation: Mutations::SaveEmailPreferences
  field :forgot_password, mutation: Mutations::ForgotPassword

  field :accept_listing_reports,
        mutation: Mutations::Admin::AcceptListingReports do
    guard ->(_obj, _args, ctx) { ctx[:current_user].admin? }
  end
  field :update_listing,
        mutation: Mutations::Admin::UpdateListing do
    guard ->(_obj, _args, ctx) { ctx[:current_user].admin? }
  end
end
