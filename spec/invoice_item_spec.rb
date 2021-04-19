require 'spec_helper'

RSpec.describe InvoiceItem do
  describe 'instantiation' do
    describe "::new" do
      it 'exists' do

        invoice_item = InvoiceItem.new({
                                        :id          => 1234567,
                                        :item_id     => "iPhone Case",
                                        :invoice_id  => "Can drop phone without breaking it",
                                        :unit_price  => BigDecimal(10.99,4),
                                        :created_at  => Time.now.to_s,
                                        :updated_at  => Time.now.to_s,
                                        :quantity    => 2
                                      })

      expect(invoice_item).to be_instance_of(InvoiceItem)
      end

      it 'converts unit price to dollars' do
        invoice_item = InvoiceItem.new({
                                        :id          => 1234567,
                                        :item_id     => "iPhone Case",
                                        :invoice_id  => "Can drop phone without breaking it",
                                        :unit_price  => 1099,
                                        :created_at  => Time.now.to_s,
                                        :updated_at  => Time.now.to_s,
                                        :quantity    => 2
                                      })

        expect(invoice_item.unit_price_to_dollars).to eq(10.99)
      end
    end
  end

end