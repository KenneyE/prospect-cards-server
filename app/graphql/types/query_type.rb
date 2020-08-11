class Types::QueryType < Types::BaseObject
  field :auth, Boolean, null: false
  def auth
    context[:current_user].present?
  end
end
