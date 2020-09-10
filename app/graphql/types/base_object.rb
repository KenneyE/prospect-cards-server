module Types
  class BaseObject < GraphQL::Schema::Object
    field_class Types::BaseField

    def client_url
      Rails.application.credentials.dig(:app, :client_url)
    end

    def current_user
      context[:current_user]
    end
  end
end
