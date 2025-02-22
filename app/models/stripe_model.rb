# Parent class for all of our models that represent Stripe objects
class StripeModel < ApplicationRecord
  self.abstract_class = true

  validates :token, presence: true, uniqueness: true

  def self.sync(stripe_obj)
    ours = find_or_initialize_by(token: stripe_obj.id)
    ours.update_from_stripe(stripe_obj)
  end

  def update_from_stripe(stripe_object)
    update(params_from_stripe_object(stripe_object))
  end

  protected

  def params_to_hash(array, subscription)
    array.index_with { |param| subscription[param] }
  end
end
