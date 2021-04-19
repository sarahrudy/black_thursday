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

# RSpec.configure do |config|
#   config.include FactoryBot::Syntax::Methods
#
#   config.before(:suite) do
#     FactoryBot.find_definitions
#   end
# end
