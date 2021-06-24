class CreateLibraries < ActiveRecord::Migration[6.1]
  def change
    create_table :libraries do |t|
      t.references :user, null: false, foreign_key: true, unique: true

      t.timestamps
    end
  end
end
