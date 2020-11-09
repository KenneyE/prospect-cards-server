class AddFieldsToStripePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    add_column :stripe_payment_methods, :brand, :text
    add_column :stripe_payment_methods, :exp_month, :integer
    add_column :stripe_payment_methods, :exp_year, :integer
    add_column :stripe_payment_methods, :last4, :text
  end
end
