module Products
  class Send < Base
    integer :new_warehouse_id
    integer :amount, default: nil

    validate :before_action_check_warehouses

    def execute
      ActiveRecord::Base.transaction do
        if send_specific_amount?
          send_product(amount, product.amount - amount)
        else
          send_product(product.amount, 0)
        end
      end
    end

    private

    def send_product(amount_to_send, leftover)
      if same_product_exists?
        same_product.update(amount: same_product.amount + amount_to_send)
        new_warehouse.create_warehouse_change
      else
        new_warehouse.products.create(name: product.name, amount: amount_to_send, price: product.price)
      end

      product.update(amount: leftover)
      product.warehouse.create_warehouse_change
    end

    def new_warehouse
      @new_warehouse ||= begin
                           warehouse = Warehouse.find_by(id: new_warehouse_id)
                           errors.add(:not_found, message: "Couldn't find Warehouse") unless warehouse
                           warehouse
                         end
    end

    def same_product
      @same_product ||= begin
                          existing_product = new_warehouse.products.find_by(name: product.name)
                          existing_product || 'none'
                        end
    end

    def same_product_exists?
      !same_product['none']
    end

    def before_action_check_warehouses
      if new_warehouse_id == product.warehouse_id
        errors.add(:same_warehouse, message: 'New warehouse has same id')
      end
    end

    alias send_specific_amount? amounts_positive?
  end
end
