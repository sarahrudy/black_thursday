require './spec/spec_helper'

RSpec.describe MerchantRepository do
  @sale_engine = SalesEngine.new
  describe 'instantiation' do
    it "::new" do
      merchant_repository = MerchantRepository.new

      expect(merchant_repository).to be_instance_of(MerchantRepository)
    end
  end

  it 'can return an array of all known merchant instances'do
      merchant_repository = @sales_engine.merchant
      merchant =

      #

end
