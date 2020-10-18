# Preview all emails at http://localhost:3000/rails/mailers/account_mailer
class AccountMailerPreview < ActionMailer::Preview
  def password_changed
    user = User.first
    AccountMailer.password_changed(user.id)
  end
end
