class CreateEmailPreferences < ActiveRecord::Migration[6.1]
  def change
    create_table :email_preferences do |t|
      t.references :user, null: false, foreign_key: true
      t.text :category, null: false
      t.boolean :canceled, null: false, default: false

      t.timestamps
    end
  end
end
