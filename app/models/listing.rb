class Listing < ApplicationRecord
  searchkick

  has_one_attached :primary_image
  has_many_attached :images

  has_many :offers

  belongs_to :user
  belongs_to :product_type
  belongs_to :category
  belongs_to :player

  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  def search_data
    {
      id: id,
      title: title,
      description: description,
      image_urls: image_urls,
      player: {
        name: player.name,
      },
      category: {
        name: category.name,
      },
      product_type: {
        name: product_type.name,
      }
    }
  end

  def image_urls
    images.map do |image|
      Rails.application.routes.url_helpers.rails_blob_url(
        image,
        host: Rails.application.credentials.dig(:app, :host),
      )
    end
  end
end
