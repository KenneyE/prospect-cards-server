# typed: true
# marks that the user agreed to pay a membership fee
class Mutations::ForgotPassword < Mutations::BaseMutation
  argument :email, String, required: true

  def resolve(email:)
    @user =
      User.find_or_initialize_with_errors(
        %i[email],
        { email: email },
        :not_found,
      )
    send_email if @user.persisted?

    raise_errors(@user)

    { message: 'Success! You will receive an email with instructions shortly!' }
  end

  def send_email
    @user.send_reset_password_instructions
  end
end
