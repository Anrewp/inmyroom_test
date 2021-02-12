module Products
  class Sell < Base
    def execute
      ActiveRecord::Base.transaction do
        if amounts_positive?
          sell_product(amount, product.amount - amount)
        else
          sell_product(product.amount, 0)
        end
      end
    end

    private

    def sell_product(product_amount, leftover)
      warehouse.update(balance: warehouse.balance + (product_amount * product.price))
      product.update(amount: leftover)
      warehouse.create_warehouse_change
    end

    def warehouse
      @warehouse ||= product.warehouse
    end
  end
end
