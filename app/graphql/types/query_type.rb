class Types::QueryType < Types::BaseObject
  field :auth, Boolean, null: false
  def auth
    context[:current_user].present?
  end

  field :viewer, Types::User, null: false
  def viewer
    context[:current_user]
  end
end
