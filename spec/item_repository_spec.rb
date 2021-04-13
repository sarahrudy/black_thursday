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
      item_repo = @sales_engine.items
      item = item_repo.create({
                          name: 'Test Item',
                          description: 'Im a test',
                          unit_price: '1.00',
                          created_at: DateTime.now.to_s,
                          updated_at: DateTime.now.to_s,
                          merchant_id: 123,
                        })
      expect(item).to be_instance_of(Item)
    end

    it 'should find item by id' do
      item_repo = @sales_engine.items
      item = item_repo.create({
                                 name: 'Test Item',
                                 description: 'Im a test',
                                 unit_price: '1.00',
                                 created_at: DateTime.now.to_s,
                                 updated_at: DateTime.now.to_s,
                                 merchant_id: 123,
                               })
      expect(item_repo.find_by_id(item.id)).to eq(item)
    end

    it 'should find item by name' do
      item_repo = @sales_engine.items
      item = item_repo.create({
                                 name: 'Test Item',
                                 description: 'Im a test',
                                 unit_price: '1.00',
                                 created_at: DateTime.now.to_s,
                                 updated_at: DateTime.now.to_s,
                                 merchant_id: 123,
                               })
      expect(item_repo.find_by_name(item.name)).to eq(item)
    end

    it 'should be able to be deleted' do
      item_repo = @sales_engine.items
      item = item_repo.create({
                                 name: 'Test Item',
                                 description: 'Im a test',
                                 unit_price: '1.00',
                                 created_at: DateTime.now.to_s,
                                 updated_at: DateTime.now.to_s,
                                 merchant_id: 123,
                               })
      expect(item_repo.find_by_id(item.id)).to eq(item)
      item_repo.delete(item.id)
      expect(item_repo.find_by_id(item.id)).to be(nil)
    end

    it 'should return all items' do
      item_repo = @sales_engine.items
      expect(item_repo.all).to eq(item_repo.items)
    end
  end
end