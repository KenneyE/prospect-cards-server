class EmailPreference < ApplicationRecord
  belongs_to :user

  def label
    category.titleize
  end
end
