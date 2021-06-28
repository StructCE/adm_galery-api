class AddUniqueIndexToRecommendations < ActiveRecord::Migration[6.1]
  def change
    add_index :recommendation_paintings, [:painting_id, :recommendation_id], unique: true, name: 'index_recommendation_painting'
  end
end
