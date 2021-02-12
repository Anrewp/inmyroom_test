module Products
  class Base < ActiveInteraction::Base
    integer :id
    integer :warehouse_id
    integer :amount

    validate  :before_action_check_product_amount

    private

    def product
      @product ||= begin
                     product = Product.find_by(id: id, warehouse_id: warehouse_id)
                     errors.add(:not_found, message: "Couldn't find Product") unless product
                     product
                   end
    end

    def before_action_check_product_amount
      errors.add(:no_product, message: 'There is no product left') unless product&.amount&.positive?
    end

    def amounts_positive?
      amount.to_i.positive? && (product.amount - amount.to_i).positive?
    end
  end
end
