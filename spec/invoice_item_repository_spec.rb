require 'spec_helper'

RSpec.describe InvoiceItemRepository do
  before(:each) do
    @sales_engine = SalesEngine.from_csv({
                            items: './data/items.csv',
                            merchants: './data/merchants.csv',
                            invoices: './data/invoices.csv',
                            invoice_items: './data/invoice_items.csv',
                            transactions: './data/transactions.csv',
                            customers: './data/customers.csv',
                         })
  end

  describe 'instantiation' do
    it "::new" do
      invoice_item_repository = @sales_engine.invoice_items

      expect(invoice_item_repository).to be_instance_of(InvoiceItemRepository)
    end
  end

  describe 'invoice items repository methods' do
    it 'can return an array of all known invoice item instances'do
      invoice_item_repository = @sales_engine.invoice_items

      # look into a different way of wording our test.
      expect(invoice_item_repository.all).to eq(invoice_item_repository.invoice_items)
    end

    it 'create invoice' do
      invoice_item_repository = @sales_engine.invoice_items
      invoice_item_1 = invoice_item_repository.create({
                                                      :item_id  => 89101112,
                                                      :invoice_id  => 13141516,
                                                      :created_at   => Time.now.to_s,
                                                      :quantity       => 4,
                                                      :unit_price       => BigDecimal(10.99,4),
                                                      :updated_at   => Time.now.to_s
                                                      })

      expect(invoice_item_1).to be_instance_of(InvoiceItem)
    end

    it 'finds invoice item by id' do
      invoice_item_repository = @sales_engine.invoice_items
      invoice_item_1 = invoice_item_repository.create({
                                                      :item_id  => 89101112,
                                                      :invoice_id  => 13141516,
                                                      :created_at   => Time.now.to_s,
                                                      :quantity       => 4,
                                                      :unit_price       => BigDecimal(10.99,4),
                                                      :updated_at   => Time.now.to_s
                                                      })


      expect(invoice_item_repository.find_by_id(invoice_item_1.id)).to eq(invoice_item_1)
    end

    it 'finds all invoice item by item id' do
      invoice_item_repository = @sales_engine.invoice_items
      invoice_item_1 = invoice_item_repository.create({
                                                      :item_id  => 89101112,
                                                      :invoice_id  => 13141516,
                                                      :created_at   => Time.now.to_s,
                                                      :quantity       => 4,
                                                      :unit_price       => BigDecimal(10.99,4),
                                                      :updated_at   => Time.now.to_s
                                                      })

      invoice_item_2 = invoice_item_repository.create({
                                                      :item_id  => 456,
                                                      :invoice_id  => 13141516,
                                                      :created_at   => Time.now.to_s,
                                                      :quantity       => 4,
                                                      :unit_price       => BigDecimal(15.00,4),
                                                      :updated_at   => Time.now.to_s
                                                      })

      expect(invoice_item_repository.find_all_by_item_id(invoice_item_1.item_id)).to eq([invoice_item_1])
    end

    it 'finds all invoice item by invoice id' do
      invoice_item_repository = @sales_engine.invoice_items
      invoice_item_1 = invoice_item_repository.create({
                                                      :item_id  => 89101112,
                                                      :invoice_id  => 13141516,
                                                      :created_at   => Time.now.to_s,
                                                      :quantity       => 4,
                                                      :unit_price       => BigDecimal(10.99,4),
                                                      :updated_at   => Time.now.to_s
                                                      })

      invoice_item_2 = invoice_item_repository.create({
                                                      :item_id  => 456,
                                                      :invoice_id  => 13141516,
                                                      :created_at   => Time.now.to_s,
                                                      :quantity       => 4,
                                                      :unit_price       => BigDecimal(15.00,4),
                                                      :updated_at   => Time.now.to_s
                                                      })

      expect(invoice_item_repository.find_all_by_invoice_id(invoice_item_1.invoice_id)).to eq([invoice_item_1, invoice_item_2])
    end

    it 'can update an invoice item' do
      invoice_item_repository = @sales_engine.invoice_items
      invoice_item_1 = invoice_item_repository.create({
                                                      :item_id  => 89101112,
                                                      :invoice_id  => 13141516,
                                                      :created_at   => Time.now.to_s,
                                                      :quantity       => 4,
                                                      :unit_price       => BigDecimal(10.99,4),
                                                      :updated_at   => Time.now.to_s
                                                      })

      invoice_item_2 = invoice_item_repository.create({
                                                      :item_id  => 456,
                                                      :invoice_id  => 13141516,
                                                      :created_at   => Time.now.to_s,
                                                      :quantity       => 4,
                                                      :unit_price       => BigDecimal(15.00,4),
                                                      :updated_at   => Time.now.to_s
                                                      })

      attributes = {quantity: 25}
      expected = invoice_item_repository.update(invoice_item_1.quantity, attributes)

      expect(expected.quantity).to eq(25)
    end

    it 'can delete invoice item' do
      invoice_item_repository = @sales_engine.invoice_items
      invoice_item_1 = invoice_item_repository.create({
                                                      :item_id  => 89101112,
                                                      :invoice_id  => 13141516,
                                                      :created_at   => Time.now.to_s,
                                                      :quantity       => 4,
                                                      :unit_price       => BigDecimal(10.99,4),
                                                      :updated_at   => Time.now.to_s
                                                      })

      invoice_item_2 = invoice_item_repository.create({
                                                      :item_id  => 456,
                                                      :invoice_id  => 13141516,
                                                      :created_at   => Time.now.to_s,
                                                      :quantity       => 4,
                                                      :unit_price       => BigDecimal(15.00,4),
                                                      :updated_at   => Time.now.to_s
                                                      })

      expect(invoice_item_repository.delete(invoice_item_1.id)).to eq(invoice_item_1)
      expect(invoice_item_repository.find_by_id(invoice_item_1.id)).to eq(nil)
    end
  end
end
