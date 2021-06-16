class Artist < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :birthdate, :birthplace, presence: true
  validates_date :birthdate
  validates_date :deathdate, allow_blank: true
  validates :name, :birthplace, length: { minimum: 3 }
  has_one_attached :picture
end
