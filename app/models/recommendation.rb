class Recommendation < ApplicationRecord
  has_many :recommendation_paintings
  has_many :paintings, through: :recommendation_paintings  

  validates :title, :description, presence: true
  validates :title, length: { minimum: 3 }
  validates :description, length: { minimum: 10 }
  validates :title, uniqueness: true
end
