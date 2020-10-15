class ListingImage < ApplicationRecord
  has_one_attached :image

  belongs_to :listing
  acts_as_list scope: :listing

  after_commit :reindex_listing

  def reindex_listing
    listing.reindex
  end
end
