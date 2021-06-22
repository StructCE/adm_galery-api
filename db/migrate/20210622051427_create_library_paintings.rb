class CreateLibraryPaintings < ActiveRecord::Migration[6.1]
  def change
    create_table :library_paintings do |t|
      t.references :library, null: false, foreign_key: true
      t.references :painting, null: false, foreign_key: true

      t.timestamps
    end
  end
end
