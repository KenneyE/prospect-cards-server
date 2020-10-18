class Mutations::SaveEmailPreferences < Mutations::BaseMutation
  argument :email_preferences, [Inputs::EmailPreferenceInput], required: true

  field :viewer, Types::User, null: false

  def resolve(email_preferences:)
    canceled = email_preferences.filter { |pref| !pref[:subscribed] }
    _update_canceled(canceled)
    _update_subscribed(canceled)

    { viewer: current_user }
  end

  private

  def _update_canceled(canceled)
    current_user.email_preferences.where(category: canceled.map(&:category))
      .find_each { |pref| pref.update(subscribed: false) }
  end

  def _update_subscribed(canceled)
    current_user.email_preferences.where.not(category: canceled.map(&:category))
      .find_each { |pref| pref.update(subscribed: true) }
  end
end
