class CreateNotices < ActiveRecord::Migration[6.1]
  def change
    create_table :notices do |t|
      t.references :user, null: false, foreign_key: true
      t.text :title, null: false
      t.text :text, null: false
      t.text :path
      t.datetime :read_at

      t.timestamps
    end
  end
end
