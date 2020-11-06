class Inputs::ProfileInput < Types::BaseInputObject
  argument :full_name, String, required: false
  argument :street1, String, required: false
  argument :street2, String, required: false
  argument :city, String, required: false
  argument :state, String, required: false
  argument :zip, String, required: false
end
