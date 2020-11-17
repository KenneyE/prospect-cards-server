class Purchase < ApplicationRecord
  belongs_to :offer
  belongs_to :listing
end
