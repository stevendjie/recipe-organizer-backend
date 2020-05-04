class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.references :recipe, null: false, foreign_key: true
      t.text :text
      t.integer :index

      t.timestamps
    end
  end
end
