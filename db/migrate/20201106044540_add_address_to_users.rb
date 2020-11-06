class AddAddressToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :text
    add_column :users, :street1, :text
    add_column :users, :street2, :text
    add_column :users, :city, :text
    add_column :users, :state, :text
    add_column :users, :zip, :text
  end
end
