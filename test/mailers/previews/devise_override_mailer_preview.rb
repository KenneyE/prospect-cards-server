# Preview all emails at http://localhost:3000/rails/mailers/devise_override_mailer
class DeviseOverrideMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    user = User.first
    DeviseOverrideMailer.confirmation_instructions(user, '123')
  end

  def reset_password_instructions
    user = User.first
    DeviseOverrideMailer.reset_password_instructions(user, '123')
  end
end
