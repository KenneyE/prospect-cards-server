class Mutations::MarkNoticesRead < Mutations::BaseMutation
  field :success, Boolean, null: false
  def resolve
    current_user.unread_notices.update_all(read_at: Time.current)

    { success: true }
  end
end
