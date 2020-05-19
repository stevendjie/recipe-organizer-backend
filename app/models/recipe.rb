class Recipe < ApplicationRecord
  belongs_to :user
  has_many :ingredients, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :equipment, dependent: :destroy
  has_many :instructions, dependent: :destroy

  validates :title, presence: true
  validates :scale_factor, numericality: { greater_than_or_equal_to: 0 }
  validates :ready_in_minutes, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
