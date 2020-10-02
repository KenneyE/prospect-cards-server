class Inputs::OfferInput < Types::BaseInputObject
  argument :price, Float, required: true
  argument :listing_id, Integer, required: true
end
