# typed: false
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      resource.send_confirmation_instructions if resource.errors.empty?
    end
  end
end
