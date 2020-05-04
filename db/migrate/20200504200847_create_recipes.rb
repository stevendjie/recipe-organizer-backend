class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.integer :ready_in_minutes
      t.text :source_url
      t.references :user, null: false, foreign_key: true
      t.decimal :scale_factor

      t.timestamps
    end
  end
end
