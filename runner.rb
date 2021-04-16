require 'pry'
require './lib/sales_engine'
require './lib/item'
require './lib/merchant'
require './lib/merchant_repository'


se = SalesEngine.from_csv({
                        :merchants => './data/merchants.csv',
                        :items => './data/items.csv'
                     })

binding.pry
