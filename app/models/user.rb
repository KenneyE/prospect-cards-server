class User < ApplicationRecord #  :timeoutable, and :omniauthable # Include default devise modules. Others available are:
  has_paper_trail

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable,
         :lockable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenyList

  after_create_commit :create_stripe_account
  has_many :listings
  belongs_to :stripe_account,
             foreign_key: :stripe_account_id, primary_key: :token

  # Override devise mailer to use ActionMailer
  # https://github.com/plataformatec/devise#activejob-integration
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  private

  def create_stripe_account
    account = Stripe::Account.create({ type: 'express' })

    StripeAccount.create(token: account.id)
    update(stripe_account_id: account.id)
  end
end
