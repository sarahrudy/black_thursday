require_relative 'spec_helper'

RSpec.describe ItemRepository do
  describe 'instantiation' do
    it '::new' do
      item_repository = engine.items

      expect(item_repository).to be_instance_of(ItemRepository)
    end
  end

  describe 'item repository methods' do
    it 'can return an array of all known item instances'do
      item_repository = engine.items

      # look into a different way of wording our test.
      expect(item_repository.all).to be_instance_of(Array)
      expect(item_repository.all.first).to be_instance_of(Item)
      expect(item_repository.all).to eq(item_repository.items)
    end

    it 'create item' do
      item_repository = engine.items
      item_1 = item_repository.create({
                                        :name => 'iPhone Case',
                                        :description => 'Can drop phone without breaking it',
                                        :unit_price => BigDecimal(1099, 4),
                                        :created_at => Time.now.to_s,
                                        :updated_at => Time.now.to_s,
                                        :merchant_id => 2
                                      })

      expect(item_1).to be_instance_of(Item)
    end

    it 'finds all items with descriptions' do
      item_repository = engine.items
      item_1 = item_repository.create({
                                        :name => 'iPhone Case',
                                        :description => 'drop phone without breaking it',
                                        :unit_price => BigDecimal(1099, 4),
                                        :created_at => Time.now.to_s,
                                        :updated_at => Time.now.to_s,
                                        :merchant_id => 2
                                      })
      item_2 = item_repository.find_by_id(263_567_475)

      expect(item_repository.find_all_with_description('Phone without Breaking')).to eq([item_2, item_1])
    end

    it 'finds all items by price' do
      item_repository = engine.items
      item_1 = item_repository.create({
                                        :name => 'iPhone Case',
                                        :description => 'Can drop phone without breaking it',
                                        :unit_price => 1099,
                                        :created_at => Time.now.to_s,
                                        :updated_at => Time.now.to_s,
                                        :merchant_id => 2
                                      })

      expect(item_repository.find_all_by_price(1099)).to include(item_1)
      expect(item_repository.find_all_by_price(1099).size).to eq(3)
    end

    it 'finds all items by price in range' do
      item_repository = engine.items
      item_1 = item_repository.create({
                                        :name => 'iPhone Case',
                                        :description => 'Can drop phone without breaking it',
                                        :unit_price => 1099,
                                        :created_at => Time.now.to_s,
                                        :updated_at => Time.now.to_s,
                                        :merchant_id => 2
                                      })
      item_2 = item_repository.create({
                                        :name => 'iPhone Case',
                                        :description => 'Can drop phone without breaking it',
                                        :unit_price => 1599,
                                        :created_at => Time.now.to_s,
                                        :updated_at => Time.now.to_s,
                                        :merchant_id => 2
                                      })

      expect(item_repository.find_all_by_price_in_range(10.00..11.00).size).to eq(70)
      expect(item_repository.find_all_by_price_in_range(10.00..11.00)).to include(item_1)
    end

    it 'finds all items by merchant id' do
      item_repository = engine.items
      item_1 = item_repository.find_by_id(263_567_475)
      item_2 = item_repository.find_by_id(263_567_476)
      item_3 = item_repository.find_by_id(263_567_477)
      item_4 = item_repository.find_by_id(263_567_478)
      item_5 = item_repository.find_by_id(263_567_479)

      expect(item_repository.find_all_by_merchant_id(item_1.merchant_id)).to eq([item_1, item_2, item_3, item_4,
                                                                                 item_5])
    end

    it 'update a specific item' do
      item_repository = engine.items
      item_1 = item_repository.find_by_id(263_567_475)

      attributes = { name: 'iPhone Protective Holder' }
      expected = item_repository.update(item_1.id, attributes)

      expect(expected.name).to eq('iPhone Protective Holder')
    end

    it 'can delete item' do
      item_repository = engine.items
      item_1 = item_repository.find_by_id(263_567_475)

      expect(item_repository.delete(item_1.id)).to eq(item_1)
      expect(item_repository.find_by_id(item_1.id)).to eq(nil)
    end
  end
end
