class CreateLibraries < ActiveRecord::Migration[6.1]
  def change
    create_table :libraries do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
