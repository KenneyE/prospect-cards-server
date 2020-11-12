class Listing < ApplicationRecord
  TAG_TYPES = [
    :category,
    :product_type,
    :manufacturer,
    :set_type,
    :player,
    :grader,
  ].freeze

  has_paper_trail
  searchkick
  scope :search_import, -> { includes(*TAG_TYPES) }
  acts_as_taggable_on TAG_TYPES
  acts_as_favoritable

  has_many :images,
           -> { order(position: :asc) },
           class_name: 'ListingImage', dependent: :destroy, inverse_of: :listing
  has_many :offers, dependent: :destroy
  has_many :listing_reports, dependent: :destroy

  belongs_to :user

  validates :title, :description, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  enum status: %i[available pending_sale sold disabled]

  def player
    player_list.first
  end

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

  private

  def tag_hash
    {
      player: player,
      category: category_list.first,
      productType: product_type_list.first,
      manufacturer: manufacturer_list.first,
      setType: set_type_list.first,
      grader: grader_list.first,
    }
  end
end
