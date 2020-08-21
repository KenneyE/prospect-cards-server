class Inputs::ListingInput < Types::BaseInputObject
  argument :id, Int, required: false
  argument :title, String, required: true
  argument :description, String, required: true
  argument :images, [ApolloUploadServer::Upload], required: true
end
