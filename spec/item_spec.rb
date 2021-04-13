require_relative 'spec_helper'

RSpec.describe Item do
  before(:each) do
    @sales_engine = SalesEngine.new
    @sales_engine.from_csv({items: './data/items.csv'})
  end
  it 'should give unit price as float' do
    item_repo = @sales_engine.items
    item = item_repo.create({
                      name: 'Test Item',
                      description: 'Im a test',
                      unit_price: '1.00',
                      created_at: DateTime.now.to_s,
                      updated_at: DateTime.now.to_s,
                      merchant_id: 123,
                    })
    expect(item.unit_price_to_dollars).to be_instance_of(Float)
  end
end