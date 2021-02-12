class Warehouse < ApplicationRecord
  has_many :products
  has_many :warehouse_changes

  after_create :create_warehouse_change

  validates :name, :address, presence: true
  validates :name, :address, uniqueness: true, length: { maximum: 50 }

  def create_warehouse_change
    warehouse_changes.create(product_count: products.sum(:amount), balance: balance)
  end
end
