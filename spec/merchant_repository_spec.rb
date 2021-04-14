require_relative 'spec_helper'

RSpec.describe MerchantRepository do
  before(:each) do
    @sales_engine = SalesEngine.from_csv({
                            merchants: './data/merchants.csv',
                         })
  end
  describe 'instantiation' do
    it "::new" do
      merchant_repository = @sales_engine.merchants

      expect(merchant_repository).to be_instance_of(MerchantRepository)
    end
  end

  describe 'merchant repository methods' do
    it 'can return an array of all known merchant instances'do
      merchant_repository = @sales_engine.merchants

      # look into a different way of wording our test.
      expect(merchant_repository.all).to eq(merchant_repository.merchants)
    end

    it 'create merchant' do
      merchant_repository = @sales_engine.merchants
      merchant_1 = merchant_repository.create({
                                              name: 'Zachs Store',
                                              created_at: DateTime.now.to_s,
                                              updated_at: DateTime.now.to_s
                                              })

      expect(merchant_1).to be_instance_of(Merchant)
    end

    it 'find by name' do
      merchant_repository = @sales_engine.merchants
      merchant_1 = merchant_repository.create({
                                              name: 'Zachs Store',
                                              created_at: DateTime.now.to_s,
                                              updated_at: DateTime.now.to_s
                                              })

      expect(merchant_repository.find_by_name(merchant_1.name)).to eq(merchant_1)
    end

    it 'find all by name' do
      merchant_repository = @sales_engine.merchants
      merchant_1 = merchant_repository.create({
                                              name: 'Zachs Store',
                                              created_at: DateTime.now.to_s,
                                              updated_at: DateTime.now.to_s
                                              })
      merchant_2 = merchant_repository.create({
                                              name: 'Zachs Store',
                                              created_at: DateTime.now.to_s,
                                              updated_at: DateTime.now.to_s
                                              })

      expect(merchant_repository.find_all_by_name(merchant_1.name)).to eq([merchant_1, merchant_2])
    end

    it 'can delete a merchant' do
      merchant_repository = @sales_engine.merchants
      merchant_1 = merchant_repository.create({
                                              name: 'Zachs Store',
                                              created_at: DateTime.now.to_s,
                                              updated_at: DateTime.now.to_s
                                              })
      merchant_2 = merchant_repository.create({
                                              name: 'Zachs Store',
                                              created_at: DateTime.now.to_s,
                                              updated_at: DateTime.now.to_s
                                              })

      expect(merchant_repository.delete(merchant_1.id)).to eq(merchant_1)
    end

    it 'can update a merchant' do
      merchant_repository = @sales_engine.merchants
      merchant_1 = merchant_repository.create({
                                              name: 'Zachs Store',
                                              created_at: DateTime.now.to_s,
                                              updated_at: DateTime.now.to_s
                                              })

        attributes = {name: 'Bobs store'}
        expected = merchant_repository.update(merchant_1.id, attributes)

      expect(expected.name).to eq('Bobs store')
    end
  end
end
