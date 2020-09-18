class Inputs::OfferInput < Types::BaseInputObject
  argument :price, Integer, required: true
  argument :listing_id, Integer, required: true
end
