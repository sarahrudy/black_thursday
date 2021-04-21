require 'rspec'
require 'simplecov'
SimpleCov.start
require './lib/merchant'
require './lib/sales_engine'
require './lib/item'
require './lib/sales_analyst'
require './lib/invoice'
require './lib/invoice_item'
require './lib/transaction'
require './lib/customer'
require './lib/sales_analyst'

module Helper
  class << self
    attr_accessor :engine
  end

  def engine
    Helper.engine
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    config.disable_monkey_patching!
    Helper.engine = SalesEngine.from_csv({
                                           items: './data/items.csv',
                                           merchants: './data/merchants.csv',
                                           invoices: './data/invoices.csv',
                                           invoice_items: './data/invoice_items.csv',
                                           transactions: './data/transactions.csv',
                                           customers: './data/customers.csv'
                                         })
  end
  config.include Helper
end
