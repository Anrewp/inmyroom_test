class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :amount, default: 0
      t.decimal :price, precision: 8, scale: 2
      t.references :warehouse, null: false, foreign_key: true

      t.timestamps
    end
  end
end
