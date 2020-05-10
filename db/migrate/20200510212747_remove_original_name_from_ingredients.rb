class RemoveOriginalNameFromIngredients < ActiveRecord::Migration[6.0]
  def change
    remove_column :ingredients, :original_name, :string
  end
end
