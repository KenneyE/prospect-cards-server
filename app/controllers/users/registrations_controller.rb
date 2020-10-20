class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super { |resource| _setup_new_user(resource) if resource.errors.empty? }
  end

  private

  def _setup_new_user(user)
    user.send_confirmation_instructions
    user.create_stripe_objects
    user.notices.create(
      title: 'Welcome to Prospect Cards!',
      text: 'Ready to start selling? Click here to start getting paid!',
      path: '/account/sell',
    )
  end
end
