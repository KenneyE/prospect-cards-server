class CreateStripePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :stripe_payment_methods do |t|
      t.text :token, null: false
      t.text :customer, null: false

      t.timestamps
    end
    add_index :stripe_payment_methods, :token
  end
end
