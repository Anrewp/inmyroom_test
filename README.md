# BACK | Stocks

# Main entities:

**Warehouse**
> (`name:` string, `address:` string, `balance:` decimal)

**Product**
> (`name:` string, `amount:` integer, `price:` decimal, `warehouse_id:` integer)

**WarehouseChange**
> (`warehouse_id:` integer, `product_count:` integer, `balance:` decimal)

### Instalation

database: PostgreSQL (install and run server if not already)

download project from github and do next steps:

```sh
$ cd inmyroom_test
$ bundle install
$ rails db:create
$ rails db:migrate
$ rails db:seed
```
to run app use:
```sh
$ rails s
```

to run tests use:
```sh
$ bundle exec rspec
```
`!!!All tests may fail on first run!!!`

# API

### Warehouse

* Get statistic for last week by default or for specific time range
* ### GET `/api/v1/warehouses/:id/statistic`
* path parameters: `id` - mandatory
* path parameters: `from_date`, `to_date` example ../statistic?from_date=2021-02-06&to_date=2021-02-11
* working example try http://localhost:3000/api/v1/warehouses/4/statistic?from_date=2021-02-06&to_date=2021-02-11

* success response: 
{
    "first_product_count": 980,
    "last_product_count": 950,
    "first_balance": "100.00",
    "last_balance": "250.00",
    "profit": 150,
    "sold_amount": 30
}
* request failure response: 400

### Products

* Sends existing product amount to another warehouse or total product amount if amount not choosen
* ### POST `/api/v1/warehouses/:warehouse_id/products/:id/send_to_warehouse`
* mandatory parameters: `id` product id, `warehouse_id` - warehouse id, `new_warehouse_id` id of warehouse to be send
* other parameters: `amount` - integer
* working example:
* send product between 2 warehouses
* http://localhost:3000/api/v1/warehouses/1/products/1/send_to_warehouse (body param: new_warehouse_id: 2)
* http://localhost:3000/api/v1/warehouses/2/products/4/send_to_warehouse (body param: new_warehouse_id: 1)

* success response: 204
* request failure response: 400



* Sell existing product amount
* ### POST `/api/v1/warehouses/:warehouse_id/products/:id/sell_product`
* mandatory parameters: `id` product id, `warehouse_id` - warehouse id, `amount` - integer
* working example:
* http://localhost:3000/api/v1/warehouses/3/products/2/sell_product (body param: amount: 10)

* success response: 204
* request failure response: 400




