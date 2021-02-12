module Api
  module V1
    class ProductsController < ApplicationController
      def send_to_warehouse
        process_outcome Products::Send.run(params)
      end

      def sell_product
        process_outcome Products::Sell.run(params)
      end
    end
  end
end
