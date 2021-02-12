class CreateWarehouses < ActiveRecord::Migration[6.0]
  def change
    create_table :warehouses do |t|
      t.string :name
      t.string :address
      t.decimal :balance, precision: 8, scale: 2, default: 0

      t.timestamps
    end
  end
end
