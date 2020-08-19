class Listing < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :title, analyzer: 'english'
      indexes :description, analyzer: 'english'
    end
  end

  belongs_to :user

  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :title, :description],
    )
  end
end
