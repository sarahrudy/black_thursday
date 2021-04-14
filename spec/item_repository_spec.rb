require 'spec_helper'

RSpec.describe ItemRepository do
  before(:each) do
    @sales_engine = SalesEngine.new
    @sales_engine.from_csv({
                            items: './data/items.csv'
                         })
  end
  describe 'instantiation' do
    it "::new" do
      item_repository = ItemRepository.new([])

      expect(item_repository).to be_instance_of(ItemRepository)
    end
  end

  describe 'item repository methods' do
    it 'can return an array of all known item instances'do
      item_repository = @sales_engine.items

      # look into a different way of wording our test.
      expect(item_repository.all).to eq(item_repository.items)
    end

    it 'create item' do
      item_repository = @sales_engine.items
      item_1 = item_repository.create({
                                      :name        => "iPhone Case",
                                      :description => "Can drop phone without breaking it",
                                      :unit_price  => BigDecimal(10.99,4),
                                      :created_at  => DateTime.now.to_s,
                                      :updated_at  => DateTime.now.to_s,
                                      :merchant_id => 2
                                    })

      expect(item_1).to be_instance_of(Item)
    end

    it 'finds all items with descriptions' do
      item_repository = @sales_engine.items
      item_1 = item_repository.create({
                                      :name        => "iPhone Case",
                                      :description => "Can drop phone without breaking it",
                                      :unit_price  => BigDecimal(10.99,4),
                                      :created_at  => DateTime.now.to_s,
                                      :updated_at  => DateTime.now.to_s,
                                      :merchant_id => 2
                                    })

      expect(item_repository.find_all_with_description(item_1.description)).to eq([item_1])
      expect(item_repository.find_all_with_description("Phone without Breaking")).to eq([item_1])
    end

    it 'finds all items by price' do
      item_repository = @sales_engine.items
      item_1 = item_repository.create({
                                      :name        => "iPhone Case",
                                      :description => "Can drop phone without breaking it",
                                      :unit_price  => BigDecimal(10.99,4),
                                      :created_at  => DateTime.now.to_s,
                                      :updated_at  => DateTime.now.to_s,
                                      :merchant_id => 2
                                    })

      expect(item_repository.find_all_by_price(BigDecimal(10.99,4))).to eq([item_1])
    end

    it 'finds all items by price in range' do
      item_repository = @sales_engine.items
      item_1 = item_repository.create({
                                      :name        => "iPhone Case",
                                      :description => "Can drop phone without breaking it",
                                      :unit_price  => BigDecimal(10.99,4),
                                      :created_at  => DateTime.now.to_s,
                                      :updated_at  => DateTime.now.to_s,
                                      :merchant_id => 2
                                    })
      item_2 = item_repository.create({
                                      :name        => "iPhone Case",
                                      :description => "Can drop phone without breaking it",
                                      :unit_price  => BigDecimal(15.99,4),
                                      :created_at  => DateTime.now.to_s,
                                      :updated_at  => DateTime.now.to_s,
                                      :merchant_id => 2
                                    })

      expect(item_repository.find_all_by_price_in_range(BigDecimal(10.00,4)..BigDecimal(11.00,4))).to eq([item_1])
    end
  end

end
