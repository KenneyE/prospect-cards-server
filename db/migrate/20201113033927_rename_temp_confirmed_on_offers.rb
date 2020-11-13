class RenameTempConfirmedOnOffers < ActiveRecord::Migration[6.1]
  def change
    rename_column :offers, :temp_confirmed, :confirmed
  end
end
