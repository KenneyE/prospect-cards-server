class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  # Only respond to JSON
  clear_respond_to
  respond_to :json
end
