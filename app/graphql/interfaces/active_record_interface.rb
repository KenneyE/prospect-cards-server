# typed: false
# Fields all models have
module Interfaces::ActiveRecordInterface
  include GraphQL::Schema::Interface

  field :id, Int, null: false

  field :createdAt, GraphQL::Types::ISO8601DateTime, null: false
  field :updatedAt, GraphQL::Types::ISO8601DateTime, null: false

  # return errors if they exist
  field :errors, [String], null: false
  def errors
    object.errors.full_messages
  end
end
