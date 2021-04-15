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
  end
end
