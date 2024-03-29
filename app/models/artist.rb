class Artist < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :biography, :birthdate, :birthplace, presence: true
  validates_date :birthdate
  validates_date :deathdate, allow_blank: true, after: :birthdate
  validates :name, :birthplace, length: { minimum: 3 }
  validates :biography, length: { minimum: 10 }
  has_one_attached :picture
  has_many :paintings, dependent: :destroy
end
