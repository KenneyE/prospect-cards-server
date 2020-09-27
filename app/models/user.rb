class User < ApplicationRecord
  include(Imgix::Rails::UrlHelper)

  searchkick

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

  after_create_commit :_create_stripe_objects

  has_one_attached :profile_picture

  has_many :listings, dependent: :destroy
  has_many :player_interests, dependent: :destroy
  has_many :players, through: :player_interests
  has_many :offers, dependent: :destroy

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

  # Override devise mailer to use ActionMailer
  # https://github.com/plataformatec/devise#activejob-integration
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def active_subscription?
    stripe_subscriptions.find_each.any?(:active?)
  end

  def search_data
    {
      id: id,
      players: {
        name: players.pluck(:name),
      },
    }
  end

  def profile_picture_url
    key = profile_picture.attached? ? profile_picture.key : 'Krispy Kards-logo-black.png'

    ix_image_url(key, height: 300)
  end

  private

  def _create_stripe_objects
    account = Stripe::Account.create(_stripe_account_opts)
    cust = Stripe::Customer.create({ email: email })

    update(
      stripe_account_id: account.id,
      stripe_customer_id: cust.id,
    )

    StripeAccount.create(token: account.id)
    StripeCustomer.create(token: cust.id)
  end

  def _stripe_account_opts
    {
      type: 'express',
      settings: { payouts: { schedule: { interval: 'manual' } } },
    }
  end
end
