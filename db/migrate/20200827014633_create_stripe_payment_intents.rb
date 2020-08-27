class CreateStripePaymentIntents < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_payment_intents do |t|
      t.text :token, null: false
      t.integer :amount, null: false
      t.text :client_secret, null: false
      t.text :customer, null: false
      t.jsonb :metadata, null: false
      t.text :status, null: false
      t.text :on_behalf_of
      t.text :transfer_group

      t.timestamps
    end
  end
end
