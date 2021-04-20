require_relative 'spec_helper'

RSpec.describe MerchantRepository do
  describe 'instantiation' do
    it '::new' do
      expect(engine.merchants).to be_instance_of(MerchantRepository)
    end
  end

  describe 'merchant repository methods' do
    it 'can return an array of all known merchant instances'do
      # look into a different way of wording our test.
      expect(engine.merchants.all.size).to eq(475)
    end

    it 'create merchant' do
      engine.merchants.create({name: 'Zachs Store'})

      expected = engine.merchants.find_by_id(12_337_412)

      expect(expected.name).to eq('Zachs Store')
    end

    it 'find by name' do
      merchant = engine.merchants.find_by_id(12_337_412)

      expect(engine.merchants.find_by_name("Zachs Store")).to eq(merchant)
    end

    it 'find all by name' do
      merchant = engine.merchants.find_by_id(12_337_412)
      merchant2 = engine.merchants.create({name: "Zachs Shop"})

      expect(engine.merchants.find_all_by_name('Zach')).to eq([merchant, merchant2])
    end

    it 'can delete a merchant' do
      merchant = engine.merchants.find_by_id(12_337_413)
      # require "pry"; binding.pry

      expect(engine.merchants.delete(merchant.id)).to eq(merchant)
      expect(engine.merchants.all).not_to include(merchant)
      expect(engine.merchants.find_by_id(merchant.id)).to eq(nil)
    end

    it 'can update a merchant' do
      merchant = engine.merchants.find_by_id(12_337_412)

      attributes = { name: 'Bobs store' }
      expected = engine.merchants.update(merchant.id, attributes)

      expect(expected.name).to eq('Bobs store')
    end
  end
end
