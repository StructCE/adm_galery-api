class CreatePaintings < ActiveRecord::Migration[6.1]
  def change
    create_table :paintings do |t|
      t.string :name
      t.string :year
      t.references :artist, null: false, foreign_key: true
      t.references :style, null: false, foreign_key: true
      t.text :description
      t.string :currentplace

      t.timestamps
    end
  end
end
