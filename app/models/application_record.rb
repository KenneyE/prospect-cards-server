class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def variant_url(att)
    Rails.application.routes.url_helpers.rails_representation_url(
      att,
      host: Rails.application.credentials.dig(:app, :host),
    )
  end
end
