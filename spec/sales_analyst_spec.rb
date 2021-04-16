require_relative 'spec_helper'

RSpec.describe SalesAnalyst do
  before(:each) do
    @sales_engine = SalesEngine.from_csv({
                            items: './data/items.csv',
                            merchants: './data/merchants.csv',
                         })
  end
  describe 'instantiation' do
    it '::new' do
      sales_analyst = @sales_engine.analyst

      expect(sales_analyst).to be_instance_of(SalesAnalyst)
    end
  end

   describe 'instance methods' do
     it '#average_items_per_merchant' do
     sales_analyst = @sales_engine.analyst

     expect(sales_analyst.average_items_per_merchant).to eq(2.88)
    end

    it '#average_items_per_merchant_standard_deviation' do
     sales_analyst = @sales_engine.analyst
     #come back to make sure it's ok to use 3.16
     expect(sales_analyst.average_items_per_merchant_standard_deviation).to eq(3.16)
    end

    it '#merchants_with_high_item_count' do
     sales_analyst = @sales_engine.analyst

     expect(sales_analyst.merchants_with_high_item_count.size).to eq(49)
    end
    it '#average_item_price_for_merchant' do

      sales_analyst = @sales_engine.analyst
      merchant = @sales_engine.merchants.create(attributes_for(:merchant))
      item_repo = @sales_engine.items
      price = BigDecimal(0)
      
      4.times do |i|
        attrs = attributes_for(:item)
        attrs[:merchant_id] = merchant.id
        # require "pry"; binding.pry
        item = item_repo.create(attrs)
        merchant.add_item(item)
        price += item.unit_price
      end
      average_price = price/4
      
      expect(sales_analyst.average_item_price_for_merchant(merchant.id)).to eq(average_price)
    end
  end
end
