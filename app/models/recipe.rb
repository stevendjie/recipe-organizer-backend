class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :equipment, dependent: :destroy
  has_many :instructions, dependent: :destroy

  validates :title, presence: true
end
