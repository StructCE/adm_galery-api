class Library < ApplicationRecord
  belongs_to :user
  has_many :library_paintings, dependent: :destroy
  has_many :paintings, through: :library_paintings

  validates :user_id, uniqueness: true
end
