# typed: false
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.errors.empty?
        resource.send_confirmation_instructions
        resource.create_stripe_objects
      end
    end
  end
end
