class CreateRecommendationPaintings < ActiveRecord::Migration[6.1]
  def change
    create_table :recommendation_paintings do |t|
      t.references :painting, null: false, foreign_key: true
      t.references :recommendation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
