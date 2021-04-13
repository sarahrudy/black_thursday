require_relative 'spec_helper'

RSpec.describe ItemRepository do
  before(:each) do
    @sales_engine = SalesEngine.new
    @sales_engine.from_csv({items: './data/items.csv'})
  end
  context 'instantiation' do
    it 'should exist' do
      ir = ItemRepository.new([])
      expect(ir).to be_instance_of(ItemRepository)
    end
  end

  context 'methods' do
    it 'should create an item' do
      items_repo = @sales_engine.items
      item = items_repo.create({
                          name: 'Test Item',
                          description: 'Im a test',
                          unit_price: '1.00',
                          created_at: DateTime.now.to_s,
                          updated_at: DateTime.now.to_s,
                          merchant_id: 123,
                        })
      expect(item).to be_instance_of(Item)
    end
  end
end