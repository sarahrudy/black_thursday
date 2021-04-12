require_relative 'spec_helper'

RSpec.describe MerchantRepository do
  before(:each) do
    @sales_engine = SalesEngine.new
  end
  describe 'instantiation' do
    it "::new" do
      merchant_repository = MerchantRepository.new([])

      expect(merchant_repository).to be_instance_of(MerchantRepository)
    end
  end

  describe 'merchant repository methods' do
    it 'can return an array of all known merchant instances'do
      merchant_repository = @sales_engine.merchants

      # look into a different way of wording our test.
      expect(merchant_repository.all).to eq(merchant_repository.merchants)
    end
  end
end
