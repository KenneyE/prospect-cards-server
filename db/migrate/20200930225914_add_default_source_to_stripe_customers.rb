class AddDefaultSourceToStripeCustomers < ActiveRecord::Migration[6.1]
  def change
    add_column :stripe_customers, :default_source, :text
  end
end
