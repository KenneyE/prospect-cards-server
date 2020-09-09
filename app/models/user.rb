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

  after_create_commit :create_stripe_objects

  has_many :listings
  has_many :stripe_payment_intents,
           foreign_key: :customer, primary_key: :stripe_customer_id
  has_many :stripe_subscriptions,
           foreign_key: :customer, primary_key: :stripe_customer_id

  belongs_to :stripe_account,
             foreign_key: :stripe_account_id, primary_key: :token
  belongs_to :stripe_customer,
             foreign_key: :stripe_customer_id, primary_key: :token

  # Override devise mailer to use ActionMailer
  # https://github.com/plataformatec/devise#activejob-integration
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def has_active_subscription?
    stripe_subscriptions.find_each.any?(:active?)
  end

  private

  def create_stripe_objects
    account =
      Stripe::Account.create(
        {
          type: 'express',
          settings: { payouts: { schedule: { interval: 'manual' } } }
        }
      )
    cust = Stripe::Customer.create({ email: email })

    StripeAccount.create(token: account.id)
    StripeCustomer.create(token: cust.id)
    update(stripe_account_id: account.id, stripe_customer_id: cust.id)
  end
end
