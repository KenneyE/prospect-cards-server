# typed: false
class Users::SessionsController < Devise::SessionsController
  private

  def respond_with(resource, _opts = {})
    render json: { token: resource }
  end

  def respond_to_on_destroy
    head :ok
  end
end
