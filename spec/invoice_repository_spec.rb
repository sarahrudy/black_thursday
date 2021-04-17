require 'spec_helper'

RSpec.describe InvoiceRepository do
  before(:each) do
    @sales_engine = SalesEngine.from_csv({
                            items: './data/items.csv',
                            merchants: './data/merchants.csv',
                            invoices: './data/invoices.csv',
                            invoice_items: './data/invoice_items.csv',
                         })
  end

  describe 'instantiation' do
    it "::new" do
      invoice_repository = @sales_engine.invoices

      expect(invoice_repository).to be_instance_of(InvoiceRepository)
    end
  end

  describe 'invoice repository methods' do
    it 'can return an array of all known invoice instances'do
      invoice_repository = @sales_engine.invoices

      # look into a different way of wording our test.
      expect(invoice_repository.all).to eq(invoice_repository.invoices)
    end

    it 'create invoice' do
      invoice_repository = @sales_engine.invoices
      invoice_1 = invoice_repository.create({
                                            :id           => 1234567,
                                            :customer_id  => 89101112,
                                            :merchant_id  => 13141516,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'pending',
                                            :updated_at   => Time.now.to_s
                                          })

      expect(invoice_1).to be_instance_of(Invoice)
    end

    it 'finds invoice by id' do
      invoice_repository = @sales_engine.invoices
      invoice_1 = invoice_repository.create({
                                            :customer_id  => 89101112,
                                            :merchant_id  => 13141516,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'pending',
                                            :updated_at   => Time.now.to_s
                                          })

      expect(invoice_repository.find_by_id(invoice_1.id)).to eq(invoice_1)
    end

    it 'find all by customer_id' do
      invoice_repository = @sales_engine.invoices
      invoice_1 = invoice_repository.create({
                                            :customer_id  => 89101112,
                                            :merchant_id  => 13141516,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'pending',
                                            :updated_at   => Time.now.to_s
                                          })
      invoice_2 = invoice_repository.create({
                                            :customer_id  => 89101112,
                                            :merchant_id  => 19876543,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'shipped',
                                            :updated_at   => Time.now.to_s
                                          })

      expect(invoice_repository.find_all_by_customer_id(invoice_1.customer_id)).to eq([invoice_1, invoice_2])
    end

    it 'find all by merchant_id' do
      invoice_repository = @sales_engine.invoices
      invoice_1 = invoice_repository.create({
                                            :customer_id  => 89101112,
                                            :merchant_id  => 13141516,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'pending',
                                            :updated_at   => Time.now.to_s
                                          })
      invoice_2 = invoice_repository.create({
                                            :customer_id  => 89101112,
                                            :merchant_id  => 19876543,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'shipped',
                                            :updated_at   => Time.now.to_s
                                          })

      expect(invoice_repository.find_all_by_merchant_id(invoice_1.merchant_id)).to eq([invoice_1])
    end

    it 'find all by status' do
      invoice_repository = @sales_engine.invoices
      invoice_1 = invoice_repository.create({
                                            :customer_id  => 89101112,
                                            :merchant_id  => 13141516,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'pending',
                                            :updated_at   => Time.now.to_s
                                          })
      invoice_2 = invoice_repository.create({
                                            :customer_id  => 89101112,
                                            :merchant_id  => 19876543,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'shipped',
                                            :updated_at   => Time.now.to_s
                                          })

      expect(invoice_repository.find_all_by_status(invoice_1.status).size).to eq(1474)
    end

    it 'can update an invoice' do
      invoice_repository = @sales_engine.invoices
      invoice_1 = invoice_repository.create({
                                            :customer_id  => 89101112,
                                            :merchant_id  => 13141516,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'pending',
                                            :updated_at   => Time.now.to_s
                                          })

      attributes = {status: 'shipped'}
      expected = invoice_repository.update(invoice_1.id, attributes)

      expect(expected.status).to eq('shipped')
    end

    it 'can delete invoice' do
      invoice_repository = @sales_engine.invoices
      invoice_1 = invoice_repository.create({
                                            :customer_id  => 89101112,
                                            :merchant_id  => 13141516,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'pending',
                                            :updated_at   => Time.now.to_s
                                          })
      invoice_2 = invoice_repository.create({
                                            :customer_id  => 89101112,
                                            :merchant_id  => 19876543,
                                            :created_at   => Time.now.to_s,
                                            :status       => 'shipped',
                                            :updated_at   => Time.now.to_s
                                          })

      expect(invoice_repository.delete(invoice_1.id)).to eq(invoice_1)
    end
  end
end
