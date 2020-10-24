class Mutations::SaveEmailPreferences < Mutations::BaseMutation
  argument :email_preferences, [Inputs::EmailPreferenceInput], required: true
  # token is used if changing preferences from the email link
  argument :token, String, required: false

  field :viewer, Types::User, null: false

  def resolve(email_preferences:, token: nil)
    @token = token
    canceled_cats =
      email_preferences.filter { |pref| !pref[:subscribed] }.map(&:category)
    _update_canceled(canceled_cats)
    _update_subscribed(canceled_cats)

    { viewer: _user, message: 'Preferences saved' }
  end

  private

  def _user
    if @token.present?
      unescaped = CGI.unescape(@token)
      user_id =
        Rails.application.message_verifier(:email_preferences).verify(unescaped)
      User.find(user_id)
    else
      current_user
    end
  end

  def _update_canceled(canceled_cats)
    _user.email_preferences.where(
      category: canceled_cats, subscribed: true,
    ).find_each { |pref| pref.update(subscribed: false) }

    newly_canceled =
      canceled_cats - _user.email_preferences.pluck(:category)

    _user.email_preferences.create(
      newly_canceled.map { |cat| { category: cat, subscribed: false } },
    )
  end

  def _update_subscribed(canceled_cats)
    _user.email_preferences.where.not(category: canceled_cats)
      .find_each { |pref| pref.update(subscribed: true) }
  end
end
