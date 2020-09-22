class CreateSetTypes < ActiveRecord::Migration[6.0]
  TYPES = [
    'Prizm',
    'Donruss Optic',
    'Select',
    'Other',
  ].freeze

  def change
    create_table :set_types do |t|
      t.text :name

      t.timestamps
    end

    SetType.create!(TYPES.map { |type| { name: type }})
  end
end
