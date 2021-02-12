# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Faker::Company.name
# Faker::Address.street_address
# Faker::Number.decimal(l_digits: 2)
# Faker::Commerce.product_name
require 'date'

case Rails.env
when 'development'

  # FOR SEND
  names = %w[1 2]
  test_product_amount_01 = 100
  test_price_01 = 5
  
  names.each do |name|
    Warehouse.create(name: name,
                     address: Faker::Address.street_address,
                     balance: Faker::Number.decimal(l_digits: 2))
  end
  Product.create(name: '1',
                 amount: test_product_amount_01,
                 price: test_price_01,
                 warehouse_id: Warehouse.find_by(name: '1').id)

  # FOR SELL
  Warehouse.create(name: 'products',
                   address: Faker::Address.street_address,
                   balance: 10)
  Product.create(name: '2',
                 amount: 1000,
                 price: 10,
                 warehouse_id: Warehouse.find_by(name: 'products').id)
  

  #FOR ANALYZE
  Warehouse.create(name: 'statistic01',
                   address: Faker::Address.street_address,
                   balance: 0)
  w = Warehouse.find_by(name: 'statistic01')
  Product.create(name: '04',
                 amount: 1000,
                 price: 5,
                 warehouse_id: w.id)
  5.times do 
    Products::Sell.run({ id: Product.find_by(name: '04').id, warehouse_id: w.id, amount: 10 })
  end
  
  date_arr = ["2021-02-01",
              "2021-02-02",
              "2021-02-06",
              "2021-02-07",
              "2021-02-08",
              "2021-02-09",
              "2021-02-10",
              "2021-02-11"]
  WarehouseChange.where(warehouse_id: w.id).order(:created_at).each_with_index do |change, index|
    break if date_arr[index].nil?
    change.update(created_at: date_arr[index])
  end
  
  # 3.times do 
  #   Warehouse.new(name: Faker::Company.name,
  #                 address: Faker::Address.street_address,
  #                 balance: Faker::Number.decimal(l_digits: 2))
  #            .save
  # end

  # warehouses_ids = Warehouse.pluck(:id)

  # 30.times do
  #   Product.new(name: Faker::Commerce.product_name,
  #               amount: rand(1..100),
  #               price: Faker::Number.decimal(l_digits: 2),
  #               warehouse_id: warehouses_ids.sample)
  #          .save
  # end


# ----- TEST ENV -----

when 'test'
  # FOR SEND TETS
  names = %w[01 02]
  test_product_amount_01 = 10
  test_price_01 = 5
  
  names.each do |name|
    Warehouse.create(name: name,
                     address: Faker::Address.street_address,
                     balance: Faker::Number.decimal(l_digits: 2))
  end
  Product.create(name: '01',
                 amount: test_product_amount_01,
                 price: test_price_01,
                 warehouse_id: Warehouse.find_by(name: '01').id)

  # FOR SELL TESTS
  Warehouse.create(name: 'with_products',
                   address: Faker::Address.street_address,
                   balance: 0)
  Product.create(name: '02',
                 amount: 1000,
                 price: 10,
                 warehouse_id: Warehouse.find_by(name: 'with_products').id)
  # FOR ANALYZE
  Warehouse.create(name: 'statistic',
                   address: Faker::Address.street_address,
                   balance: 0)
  w = Warehouse.find_by(name: 'statistic')
  Product.create(name: '03',
                 amount: 1000,
                 price: 5,
                 warehouse_id: w.id)
  5.times do
    Products::Sell.run({ id: Product.find_by(name: '03').id, warehouse_id: w.id, amount: 10 })
  end
  
  date_arr2 = ["2021-02-01", 
               "2021-02-02", 
               "2021-02-06", 
               "2021-02-07", 
               "2021-02-08", 
               "2021-02-09", 
               "2021-02-10", 
               "2021-02-11"]
  WarehouseChange.where(warehouse_id: w.id).order(:created_at).each_with_index do |change, index|
    break if date_arr2[index].nil?
    change.update(created_at: date_arr2[index])
  end
end
