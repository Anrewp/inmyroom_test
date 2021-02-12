require 'rails_helper'

RSpec.describe 'App tests' do

  context 'Check send logic' do
    w1 = Warehouse.find_by(name: '01')
    w2 = Warehouse.find_by(name: '02')
    p1 = Product.first

    it 'SEND HALF' do
      # product amount = 10
      send_amount = 5
      result = 5
      first_warehouse_changes_count = 3
      second_warehouse_changes_count = 2

      Products::Send.run({ id: p1.id, warehouse_id: w1.id, new_warehouse_id: w2.id, amount: send_amount })

      expect(w2.products.first.amount).to eq(result)
      expect(w1.products.first.amount).to eq(result)
      expect(w1.warehouse_changes.size).to eq(first_warehouse_changes_count)
      expect(w2.warehouse_changes.size).to eq(second_warehouse_changes_count)

      # SEND TO SELF
      outcome = Products::Send.run({ id: p1.id, warehouse_id: w1.id, new_warehouse_id: w1.id, amount: send_amount })

      expect(outcome.valid?).to eq(false)
      expect(outcome.errors).to have_key(:same_warehouse)
      expect(w2.products.first.amount).to eq(result)
      expect(w1.products.first.amount).to eq(result)
    end

    it 'SEND ALL' do
      # product amount = 10
      send_amount = 1000
      delivered = 10
      leftover = 0

      Products::Send.run({ id: p1.id, warehouse_id: w1.id, new_warehouse_id: w2.id, amount: send_amount })

      expect(w2.products.first.amount).to eq(delivered)
      expect(w1.products.first.amount).to eq(leftover)

      # SEND ALL BACK (WITHOUT AMOUNT)
      p2 = w2.products.first

      Products::Send.run({ id: p2.id, warehouse_id: w2.id, new_warehouse_id: w1.id })

      expect(w1.products.first.amount).to eq(delivered)
      expect(w2.products.first.amount).to eq(leftover)

      # SEND AGAIN
      outcome = Products::Send.run({ id: p2.id, warehouse_id: w2.id, new_warehouse_id: w1.id })

      expect(outcome.valid?).to eq(false)
      expect(outcome.errors).to have_key(:no_product)
      expect(w1.products.first.amount).to eq(delivered)
      expect(w2.products.first.amount).to eq(leftover)
    end
  end

  context 'Check sell logic' do
    warehouse = Warehouse.find_by(name: 'with_products')
    product = Product.find_by(name: '02')

    it 'SELL AMOUNT' do
      # product price 10
      sell_amount = 5
      result_balance = 50

      Products::Sell.run({ id: product.id, warehouse_id: warehouse.id, amount: sell_amount })
      expect(warehouse.reload.balance).to eq(result_balance)
      expect(warehouse.warehouse_changes.size).to eq(3)
    end

    it 'SELL ALL' do
      # product price 10
      sell_amount = 10_000
      result_balance = 10_000

      Products::Sell.run({ id: product.id, warehouse_id: warehouse.id, amount: sell_amount })
      expect(warehouse.reload.balance).to eq(result_balance)
      expect(warehouse.warehouse_changes.size).to eq(3)

      # TRY TO SELL MORE
      outcome = Products::Sell.run({ id: product.id, warehouse_id: warehouse.id, amount: sell_amount })
      expect(outcome.valid?).to eq(false)
      expect(outcome.errors).to have_key(:no_product)
      expect(warehouse.reload.balance).to eq(result_balance)
      expect(product.reload.amount).to eq(0)
      expect(warehouse.warehouse_changes.size).to eq(3)
    end
  end

  context 'Check Warehouse analyze logic' do
    warehouse = Warehouse.find_by(name: 'statistic')

    it 'GET DATA' do
      outcome = Warehouses::Analyze.run({ id: warehouse.id })
      # product price = 5 
      # product amount = 1000
      resutl_hash = { "first_balance"=>"50.00", 
                      "first_product_count"=>990,
                      "last_balance"=>"300.00",
                      "last_product_count"=>940, 
                      "profit"=>250.0, 
                      "sold_amount"=>50.0 }

      expect(outcome.result).to eq(resutl_hash)
    end
  end
end
