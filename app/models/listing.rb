class Listing < ApplicationRecord
  searchkick

  has_paper_trail

  has_one_attached :primary_image
  has_many_attached :images

  has_many :offers, dependent: :destroy

  belongs_to :user
  belongs_to :product_type
  belongs_to :manufacturer
  belongs_to :set_type
  belongs_to :grader, optional: true
  belongs_to :category
  belongs_to :player

  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  def search_data
    {
      id: id,
      title: title,
      description: description,
      imageUrls: image_urls,
      rookie: rookie?,
      price: price,
      user: {
        id: user_id,
      },
      player: {
        name: player.name,
      },
      category: {
        name: category.name,
      },
      productType: {
        name: product_type.name,
      },
      manufacturer: {
        name: manufacturer.name,
      },
      setType: {
        name: set_type.name,
      },
      grader: {
        name: grader.name,
      },
    }
  end

  def image_urls
    images.map do |image|
      variant_url(image.variant(resize_to_limit: [170, nil]))
    end
  end
end
