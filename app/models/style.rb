class Style < ApplicationRecord
  has_many :paintings, dependent: :destroy
  validates :title, :description, presence: true
  validates :title, length: { minimum: 3 }
  validates :description, length: { minimum: 10 }
  validates :title, uniqueness: true
end
