class Inputs::ListingInput < Types::BaseInputObject
  argument :id, Int, required: false
  argument :title, String, required: true
  argument :description, String, required: true
  argument :images, [ApolloUploadServer::Upload], required: true
  argument :category_id, Integer, required: true
  argument :product_type_id, Integer, required: true
  argument :manufacturer_id, Integer, required: true
  argument :set_type_id, Integer, required: true
  argument :grader_id, Integer, required: true
end
