class CreateStripeCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_customers do |t|
      t.text :token
      t.index :token

      t.timestamps
    end
  end
end
