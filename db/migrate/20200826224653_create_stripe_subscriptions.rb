class CreateStripeSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :stripe_subscriptions do |t|
      t.text :token, null: false
      t.text :customer, null: false
      t.boolean :cancel_at_period_end, null: false
      t.integer :current_period_start, null: false
      t.integer :current_period_end, null: false
      t.integer :quantity, null: false
      t.text :status, null: false
      t.integer :trial_end
      t.text :plan, null: false
      t.integer :created, null: false
      t.jsonb :metadata
      t.jsonb :discount

      t.timestamps
    end
  end
end
