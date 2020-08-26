class Listing < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  mapping dynamic: :strict do
    indexes :id, type: :long
    indexes :title, type: :text
    indexes :description, type: :text
    indexes :image, type: :text

    indexes :player do
      indexes :name, type: :keyword
    end
  end

  has_one_attached :primary_image
  has_many_attached :images

  belongs_to :user
  belongs_to :player

  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  def as_indexed_json(options = {})
    self.as_json(
      methods: :image,
      only: %i[id title description],
      include: { player: { only: :name } }
    )
  end

  def image
    Rails.application.routes.url_helpers.rails_blob_url(
      images.first,
      host: Rails.application.credentials.dig(:app, :host)
    )
  end
end
