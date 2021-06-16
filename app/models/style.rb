class Style < ApplicationRecord
  # has_many :paintings

  validates :title, :description, presence: true
  validates_length_of :title, minimum: 3
  validates_length_of :description, minimum: 10
  validates :title, uniqueness: true
end
