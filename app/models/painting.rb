class Painting < ApplicationRecord
  belongs_to :artist
  belongs_to :style
  has_many :library_paintings, dependent: :destroy
  has_many :libraries, through: :library_paintings
  validates :name, :year, :artist_id, :style_id, :description, :currentplace, presence: true
  validates :name, :year, :currentplace, length: { minimum: 3 }
  validates :description, length: { minimum: 10 }
  has_one_attached :image
end
