class Inputs::Admin::ListingInput < Types::BaseInputObject
  graphql_name 'AdminListingInput'

  argument :id, Int, required: true
  argument :status, Enums::ListingStatusEnum, required: false
end
