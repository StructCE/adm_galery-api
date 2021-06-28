class RecommendationPainting < ApplicationRecord
  belongs_to :painting
  belongs_to :recommendation

  validates :recommendation, :painting, presence: true
  validates :painting, uniqueness: { scope: :recommendation }
end
