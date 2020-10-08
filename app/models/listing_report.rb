class ListingReport < ApplicationRecord
  MAX_REPORTS = 3

  belongs_to :listing
  belongs_to :user

  validates :text, presence: true

  scope :unreviewed, -> { where(reviewed_at: nil) }
end
