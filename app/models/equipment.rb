class Equipment < ApplicationRecord
  belongs_to :recipe

  validates :in_shopping_list, inclusion: { in: [true, false] }
  validates_numericality_of :shopping_list_index, only_integer: true, allow_nil: true
end
