# typed: false
class Users::SessionsController < Devise::SessionsController
  # Only respond to JSON
  clear_respond_to
  respond_to :json

  def create
    resource =
      User.find_for_database_authentication(email: params[:user][:email])

    return invalid_login_attempt unless resource

    if resource.valid_password?(params[:user][:password])
      if resource.active_for_authentication?
        sign_in(resource)
        render json: {
          success: true,
          admin: { email: resource.email, id: resource.id },
        }, status: 200
      else
        invalid_login_attempt(message: I18n.t('users.failure.unconfirmed'))
      end
    else
      invalid_login_attempt
    end
  end

  protected ######################### PROTECTED #########################

  def invalid_login_attempt(message: 'Wrong email or password')
    warden.custom_failure!
    render json: { success: false, message: message }, status: 401
  end

  def respond_to_on_destroy
    render json: { admin: nil }, status: 200
  end
end
