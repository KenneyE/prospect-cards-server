class Types::Listing < Types::ActiveRecordObject
  field :title, String, null: false
  field :description, String, null: false
  field :price, Integer, null: false
  field :status, Enums::ListingStatusEnum, null: false
  field :images, [Types::ListingImage], null: false

  field :player, String, null: false
  field :offers, [Types::Offer], null: false

  field :reports, [Types::ListingReport], null: false
  def reports
    raise(StandardError, 'Unauthorized') unless current_user.admin?

    object.listing_reports
  end
end
