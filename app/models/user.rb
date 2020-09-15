class User < ApplicationRecord #  :timeoutable, and :omniauthable # Include default devise modules. Others available are:
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

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

  after_validation :create_stripe_objects, on: :create

  has_many :listings, dependent: :destroy
  has_many :player_interests, dependent: :destroy
  has_many :players, through: :player_interests

  has_many :stripe_payment_intents,
           foreign_key: :customer,
           primary_key: :stripe_customer_id,
           dependent: :destroy,
           inverse_of: :user
  has_many :stripe_subscriptions,
           foreign_key: :customer,
           primary_key: :stripe_customer_id,
           dependent: :destroy,
           inverse_of: :user
  has_one :stripe_account,
          foreign_key: :token,
          primary_key: :stripe_account_id,
          dependent: :destroy,
          inverse_of: :user

  has_one :stripe_customer,
          foreign_key: :token,
          primary_key: :stripe_customer_id,
          dependent: :destroy,
          inverse_of: :user

  mapping dynamic: :strict do
    indexes :id, type: :long
    indexes :players do
      indexes :name, type: :keyword
    end
  end

  # Override devise mailer to use ActionMailer
  # https://github.com/plataformatec/devise#activejob-integration
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def has_active_subscription?
    stripe_subscriptions.find_each.any?(:active?)
  end

  def as_indexed_json(options = {})
    self.as_json(only: %i[id], include: { players: { only: :name } })
  end

  private

  def create_stripe_objects
    account = Stripe::Account.create(stripe_account_opts)

    cust = Stripe::Customer.create({ email: email })

    StripeAccount.create(token: account.id)
    StripeCustomer.create(token: cust.id)

    self.stripe_account_id = account.id
    self.stripe_customer_id = cust.id
  end

  def stripe_account_opts
    {
      type: 'express',
      settings: { payouts: { schedule: { interval: 'manual' } } }
    }
  end
end
