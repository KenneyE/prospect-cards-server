class CreateGraders < ActiveRecord::Migration[6.0]
  GRADERS = %w[PSA BGS SGC Other].freeze

  def change
    create_table :graders do |t|
      t.text :name

      t.timestamps
    end

    Grader.create!(GRADERS.map { |type| { name: type } })
  end
end
