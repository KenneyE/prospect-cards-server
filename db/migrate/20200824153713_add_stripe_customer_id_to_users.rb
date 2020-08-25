class AddStripeCustomerIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stripe_customer_id, :text
    add_column :stripe_accounts, :details_submitted, :boolean, null: false, default: false
  end
end
