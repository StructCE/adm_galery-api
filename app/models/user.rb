class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :image

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates :name, length: { minimum: 3, message: 'Nome deve ter ao menos 3 caracteres.' }
end
