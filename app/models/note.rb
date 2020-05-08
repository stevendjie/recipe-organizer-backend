class Note < ApplicationRecord
  belongs_to :recipe

  validates :index, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
