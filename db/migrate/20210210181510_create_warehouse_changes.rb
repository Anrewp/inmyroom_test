class CreateWarehouseChanges < ActiveRecord::Migration[6.0]
  def change
    create_table :warehouse_changes do |t|
      t.references :warehouse, null: false, foreign_key: true
      t.integer :product_count
      t.decimal :balance, precision: 8, scale: 2

      t.timestamps
    end
  end
end
