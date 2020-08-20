class Listing < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_one_attached :primary_image
  has_many_attached :images

  belongs_to :user
  belongs_to :player

  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :title, :description],
      include: {
        player: { only: :name }
      }
    )
  end
end
