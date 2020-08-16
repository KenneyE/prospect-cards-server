class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  before_action :set_paper_trail_whodunnit

  # Only respond to JSON
  clear_respond_to
  respond_to :json
end
