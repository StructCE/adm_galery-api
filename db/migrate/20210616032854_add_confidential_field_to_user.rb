class AddConfidentialFieldToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :confidential, :boolean
  end
end
