class AddUserUniqueIndexToLibrary < ActiveRecord::Migration[6.1]
  def change
    remove_index :libraries, :user_id
    add_index :libraries, :user_id, unique: true
  end
end
