class AddPaymentIntentIdToOffers < ActiveRecord::Migration[6.1]
  def change
    Offer.destroy_all
    add_column :offers, :payment_intent_id, :text, null: false
  end
end
