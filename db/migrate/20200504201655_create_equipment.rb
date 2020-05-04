class CreateEquipment < ActiveRecord::Migration[6.0]
  def change
    create_table :equipment do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :name
      t.boolean :in_shopping_list
      t.integer :shopping_list_index

      t.timestamps
    end
  end
end
