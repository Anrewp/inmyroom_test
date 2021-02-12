module Warehouses
  class Analyze < ActiveInteraction::Base
    integer :id
    string :from_date, default: (Date.current - 1.week).to_s
    string :to_date, default: Date.current.to_s

    validate :check_dates

    def execute
      ActiveRecord::Base.connection.execute(sql).to_a[0].tap do |result|
        result['profit'] = result['last_balance'].to_f - result['first_balance'].to_f
        result['sold_amount'] = result['first_product_count'].to_f - result['last_product_count'].to_f
      end
    end

    private

    def check_dates
      from_date.to_date
      to_date.to_date
    rescue ArgumentError
      errors.add(:not_date, message: 'Not date format')
    end

    def sql
      "SELECT (
         SELECT product_count
         FROM warehouse_changes
         WHERE warehouse_id = #{id}
         AND created_at = (
           SELECT MIN(created_at)
           FROM warehouse_changes
           WHERE warehouse_id = #{id}
           AND created_at BETWEEN '#{from_date}' AND '#{to_date}'
         ) LIMIT 1
       ) AS first_product_count,
       (
         SELECT product_count
         FROM warehouse_changes
         WHERE warehouse_id = #{id}
         AND created_at = (
           SELECT MAX(created_at)
           FROM warehouse_changes
           WHERE warehouse_id = #{id}
           AND created_at BETWEEN '#{from_date}' AND '#{to_date}'
         ) LIMIT 1
       ) AS last_product_count,
       (
         SELECT balance
         FROM warehouse_changes
         WHERE warehouse_id = #{id}
         AND created_at = (
           SELECT MIN(created_at)
           FROM warehouse_changes
           WHERE warehouse_id = #{id}
           AND created_at BETWEEN '#{from_date}' AND '#{to_date}'
         ) LIMIT 1
       ) AS first_balance,
       (
         SELECT balance
         FROM warehouse_changes
         WHERE warehouse_id = #{id}
         AND created_at = (
           SELECT MAX(created_at)
           FROM warehouse_changes
           WHERE warehouse_id = #{id}
           AND created_at BETWEEN '#{from_date}' AND '#{to_date}'
         ) LIMIT 1
       ) AS last_balance
       FROM warehouse_changes
       WHERE warehouse_id = #{id}
       GROUP BY warehouse_id"
    end
  end
end
