class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super { |resource| _setup_new_user(resource) if resource.errors.empty? }
  end

  private

  def _setup_new_user(user)
    user.setup_new_user
  end
end
