class Product < ApplicationRecord
  belongs_to :warehouse

  after_create -> { warehouse.create_warehouse_change }

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :warehouse_id
end
