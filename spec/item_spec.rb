require 'spec_helper'

RSpec.describe Item do
  describe 'instantiation' do
    describe "::new" do
      it 'exists' do

        item = Item.new({
                        :id          => 1234567,
                        :name        => "iPhone Case",
                        :description => "Can drop phone without breaking it",
                        :unit_price  => BigDecimal(10.99,4),
                        :created_at  => Time.now.to_s,
                        :updated_at  => Time.now.to_s,
                        :merchant_id => 2
                      })

      expect(item).to be_instance_of(Item)
      end

      it 'converts unit price to dollars' do
        item = Item.new({
                        :id          => 1234567,
                        :name        => "iPhone Case",
                        :description => "Can drop phone without breaking it",
                        :unit_price  => 1099,
                        :created_at  => Time.now.to_s,
                        :updated_at  => Time.now.to_s,
                        :merchant_id => 2
                      })

        expect(item.unit_price_to_dollars).to eq(10.99)
      end
    end
  end

end
