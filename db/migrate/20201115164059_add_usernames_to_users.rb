class AddUsernamesToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :username, :text
    User.find_each { |u| puts u.email; u.update!(username: u.email.split('@')[0]) }
    change_column_null :users, :username, false

    add_index :users, :username, unique: true
  end
end
