class Inputs::ListingInput < Types::BaseInputObject
  argument :id, Int, required: false
  argument :title, String, required: true
  argument :description, String, required: true
  argument :price, Float, required: true
  argument :images, [ApolloUploadServer::Upload], required: true
  argument :category, String, required: true
  argument :product_type, String, required: true
  argument :manufacturer, String, required: true
  argument :set_type, String, required: true
  argument :grader, String, required: false
  argument :parallel, String, required: false
  argument :player, String, required: false
end
