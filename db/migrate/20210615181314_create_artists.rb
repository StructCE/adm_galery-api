class CreateArtists < ActiveRecord::Migration[6.1]
  def change
    create_table :artists do |t|
      t.string :name
      t.text :biography
      t.date :birthdate
      t.date :deathdate
      t.string :birthplace

      t.timestamps
    end
  end
end
