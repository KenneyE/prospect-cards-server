# frozen_string_literal: true

class ActsAsFavoritorMigration < ActiveRecord::Migration[6.1]
  def self.up
    create_table :favorites, force: true do |t|
      t.references :favoritable, polymorphic: true, null: false
      t.references :favoritor, polymorphic: true, null: false
      t.string :scope, default: ActsAsFavoritor.configuration.default_scope,
                       null: false,
                       index: true
      t.boolean :blocked, default: false, null: false, index: true
      t.timestamps
    end

    add_index :favorites,
              ['favoritor_id', 'favoritor_type'],
              name: 'fk_favorites'
    add_index :favorites,
              ['favoritable_id', 'favoritable_type'],
              name: 'fk_favoritables'

    add_column :listings, :favoritable_score, :text
    add_column :listings, :favoritable_total, :text
  end

  def self.down
    drop_table :favorites
    remove_column :listings, :favoritable_score, :text
    remove_column :listings, :favoritable_total, :text
  end
end
