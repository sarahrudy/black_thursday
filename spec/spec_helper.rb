require 'rspec'
require 'simplecov'
SimpleCov.start
require './lib/merchant_repository'
require './lib/merchant'
require './lib/sales_engine'
require './lib/item_repository'
require './lib/item'
require './lib/sales_analyst'
require 'factory_bot'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
