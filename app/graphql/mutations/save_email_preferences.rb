class Mutations::SaveEmailPreferences < Mutations::BaseMutation
  argument :email_preferences, [Inputs::EmailPreferenceInput], required: true

  field :viewer, Types::User, null: false

  def resolve(email_preferences:)
    canceled_cats =
      email_preferences.filter { |pref| !pref[:subscribed] }.map(&:category)
    _update_canceled(canceled_cats)
    _update_subscribed(canceled_cats)

    { viewer: current_user, message: 'Preferences saved' }
  end

  private

  def _update_canceled(canceled_cats)
    current_user.email_preferences.where(
      category: canceled_cats, subscribed: true,
    ).find_each { |pref| pref.update(subscribed: false) }

    newly_canceled =
      canceled_cats - current_user.email_preferences.pluck(:category)

    current_user.email_preferences.create(
      newly_canceled.map { |cat| { category: cat, subscribed: false } },
    )
  end

  def _update_subscribed(canceled_cats)
    current_user.email_preferences.where.not(category: canceled_cats)
      .find_each { |pref| pref.update(subscribed: true) }
  end
end
