class AddTempConfirmedToOffers < ActiveRecord::Migration[6.1]
  def change
    add_column :offers, :temp_confirmed, :boolean, null: false, default: false
  end
end
