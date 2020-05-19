class Ingredient < ApplicationRecord
  belongs_to :recipe

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :in_shopping_list, inclusion: { in: [true, false] }
  validates_numericality_of :shopping_list_index, only_integer: true, allow_nil: true
end
