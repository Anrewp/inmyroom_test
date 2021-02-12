module Api
  module V1
    class WarehousesController < ApplicationController
      def statistic
        process_outcome Warehouses::Analyze.run(params) do |statistic|
          render json: statistic
        end
      end
    end
  end
end
