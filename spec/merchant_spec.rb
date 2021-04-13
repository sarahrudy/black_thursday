require './spec/spec_helper'

RSpec.describe Merchant do
  describe 'instantiation' do
    describe "::new" do
      it 'exists' do

        merchant = Merchant.new({
                              id: 12334105,
                              name: 'Shopin1901',
                              created_at: '2010-12-10',
                              updated_at: '2011-12-04'
                            })

      expect(merchant).to be_instance_of(Merchant)
      end
    end
  end

end
