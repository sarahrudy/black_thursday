require_relative 'spec_helper'

RSpec.describe MerchantRepository do
  before(:each) do
    @sales_engine = SalesEngine.from_csv({
                            items: './data/items.csv',
                            merchants: './data/merchants.csv',
                         })
  end
  describe 'instantiation' do
    it "::new" do

      expect(@sales_engine.merchants).to be_instance_of(MerchantRepository)
    end
  end

  describe 'merchant repository methods' do
    it 'can return an array of all known merchant instances'do

      # look into a different way of wording our test.
      expect(@sales_engine.merchants.all.size).to eq(475)
    end

    it 'create merchant' do
      @sales_engine.merchants.create({
                                      name: 'Zachs Store',
                                      })

      expected = @sales_engine.merchants.find_by_id(12337412)

      expect(expected.name).to eq('Zachs Store')
    end

    it 'find by name' do
      merchant_1 = @sales_engine.merchants.create(attributes_for(:merchant))

      expect(@sales_engine.merchants.find_by_name(merchant_1.name)).to eq(merchant_1)
    end

    it 'find all by name' do
      merchant_1 = @sales_engine.merchants.create(attributes_for(:merchant))

      expect(@sales_engine.merchants.find_all_by_name(merchant_1.name)).to eq([merchant_1])
    end

    it 'can delete a merchant' do
      merchant_1 = @sales_engine.merchants.create(attributes_for(:merchant))

      expect(@sales_engine.merchants.delete(merchant_1.id)).to eq(merchant_1)
      expect(@sales_engine.merchants.all).not_to include(merchant_1) 
    end

    it 'can update a merchant' do
      merchant_1 = @sales_engine.merchants.create(attributes_for(:merchant))

        attributes = {name: 'Bobs store'}
        expected = @sales_engine.merchants.update(merchant_1.id, attributes)

      expect(expected.name).to eq('Bobs store')
    end
  end
end
