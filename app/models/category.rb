class Category < ApplicationRecord
  has_many :listings, dependent: :nullify
end
