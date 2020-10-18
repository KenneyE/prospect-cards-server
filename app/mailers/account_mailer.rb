class AccountMailer < ApplicationMailer
  def password_changed(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: 'Prospect Cards Password Changed')
  end
end
