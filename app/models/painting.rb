class Painting < ApplicationRecord
  belongs_to :artist
  belongs_to :style
  validates :name, :year, :artist_id, :style_id, :description, :currentplace, presence: true
  validates :name, :year, :currentplace, length: { minimum: 3 }
  validates :description, length: { minimum: 10 }
  has_one_attached :image

  has_many :recommendation_paintings
  has_many :recommendations, through: :recommendation_paintings
end
