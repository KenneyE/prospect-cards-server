class Listing < ApplicationRecord
  searchkick
  scope :search_import, -> { available }

  has_paper_trail

  has_many :images,
           -> { order(position: :asc) },
           class_name: 'ListingImage', dependent: :destroy, inverse_of: :listing
  has_many :offers, dependent: :destroy
  has_many :listing_reports, dependent: :destroy

  belongs_to :user
  belongs_to :product_type
  belongs_to :manufacturer
  belongs_to :set_type
  belongs_to :grader, optional: true
  belongs_to :category
  belongs_to :player

  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  enum status: %i[available pending_sale sold disabled]

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def search_data
    {
      id: id,
      title: title,
      description: description,
      images: image_urls,
      createdAt: created_at,
      rookie: rookie?,
      price: price,
      status: status,
      user: { id: user_id },
      player: { name: player.name },
      category: { name: category.name },
      productType: { name: product_type.name },
      manufacturer: { name: manufacturer.name },
      setType: { name: set_type.name },
      grader: { name: grader.name },
    }
  end # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def image_urls
    images.map do |image|
      next unless image.image.attached?

      {
        url: variant_url(image.image.variant(resize_to_limit: [240, nil])),
        position: image.position,
      }
    end
  end

  def should_index?
    available?
  end
end
