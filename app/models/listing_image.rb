class ListingImage < ApplicationRecord
  include(Imgix::Rails::UrlHelper)

  has_one_attached :image

  belongs_to :listing
  acts_as_list scope: :listing

  after_commit :reindex_listing

  def url
    # variant_url(image.variant(resize_to_limit: [240, nil]))
    ix_image_url(image.key, height: 240, fm: 'webp')
  end

  private

  def reindex_listing
    listing.reindex
  end
end
