class CreateStripeAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_accounts do |t|
      t.text :token
      t.boolean :charges_enabled, null: false, default: false

      t.index :token

      t.timestamps
    end
  end
end
