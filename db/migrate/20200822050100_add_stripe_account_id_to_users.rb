class AddStripeAccountIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stripe_account_id, :text
  end
end
