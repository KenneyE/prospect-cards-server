class Listing < ApplicationRecord
  TAG_TYPES = [
    :categories,
    :product_types,
    :manufacturers,
    :set_types,
    :players,
    :graders,
  ].freeze

  has_paper_trail
  searchkick
  scope :search_import, -> { includes(*TAG_TYPES) }
  acts_as_taggable_on TAG_TYPES

  has_many :images,
           -> { order(position: :asc) },
           class_name: 'ListingImage', dependent: :destroy, inverse_of: :listing
  has_many :offers, dependent: :destroy
  has_many :listing_reports, dependent: :destroy

  belongs_to :user
  belongs_to :grader, optional: true
  belongs_to :player

  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  enum status: %i[available pending_sale sold disabled]

  # rubocop:disable Metrics/MethodLength
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
    }.merge(tag_hash)
  end
  # rubocop:enable Metrics/MethodLength

  def tag_hash
    {
      player: player_list,
      category: category_list,
      productType: product_type_list,
      manufacturer: manufacturer_list,
      setType: set_type_list,
      grader: grader_list,
    }
  end

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
