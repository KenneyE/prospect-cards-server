class User < ApplicationRecord
  include(Imgix::Rails::UrlHelper)

  searchkick
  acts_as_favoritor
  has_paper_trail

  devise :invitable,
         :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :trackable,
         :confirmable,
         :lockable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenyList

  has_one_attached :profile_picture

  has_many :listings, dependent: :destroy
  has_many :incoming_offers, through: :listings, source: :offers
  has_many :notices, dependent: :destroy

  has_many :offers, dependent: :destroy
  has_many :purchases, through: :offers

  has_many :email_preferences, dependent: :destroy

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
  has_many :stripe_payment_methods, through: :stripe_customer
  has_many :stripe_payment_intents, through: :stripe_customer

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :username, format: { with: /^[a-zA-Z0-9_+.]*$/, multiline: true }

  # https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  attr_writer :login

  # Override devise mailer to use ActionMailer
  # https://github.com/plataformatec/devise#activejob-integration
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def self.send_invite!(email)
    # Database requires a username, so use a placeholder. Will be overriden
    # when user accepts invitation
    User.invite!({ email: email, username: Base64.encode64(email) })
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    conditions[:email]&.downcase!
    login = conditions.delete(:login)

    where(conditions.to_h).find_by(
      [
        'lower(username) = :value OR lower(email) = :value',
        { value: login.downcase },
      ],
    )
  end

  def login
    @login || username || email
  end

  def create_stripe_objects
    account = Stripe::Account.create(_stripe_account_opts)
    cust = Stripe::Customer.create({ email: email })

    update(stripe_account_id: account.id, stripe_customer_id: cust.id)

    StripeAccount.create(token: account.id)
    StripeCustomer.create(token: cust.id)
  end

  def active_subscription?
    stripe_subscriptions.find_each.any?(:active?)
  end

  def payment_method?
    stripe_payment_methods.any?
  end

  def payment_method
    stripe_payment_methods.order(:created_at).last
  end

  def search_data
    { id: id }
  end

  def profile_picture_url
    if profile_picture.attached?
      variant_url(profile_picture.variant(resize_to_limit: [200, nil]))
    else
      ix_image_url('Krispy Kards-logo-black.png', height: 200)
    end
  end

  def unread_notices
    notices.unread.order(created_at: :desc)
  end

  def orders; end

  def setup_new_user
    send_confirmation_instructions
    create_stripe_objects
    notices.create(
      title: 'Welcome to Prospect Cards!',
      text: 'Ready to start selling? Click here to start getting paid!',
      path: '/account/sell',
    )
  end

  private

  def _stripe_account_opts
    {
      type: 'express',
      settings: { payouts: { schedule: { interval: 'manual' } } },
    }
  end

  # Tells devise to use our custom mailer
  def devise_mailer
    DeviseOverrideMailer
  end
end
