# typed: false
class Users::SessionsController < Devise::SessionsController
  private

  def respond_to_on_destroy
    head :ok
  end
end
