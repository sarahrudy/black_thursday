require 'spec_helper'

RSpec.describe InvoiceRepository do
  let(:invoice_repository) { engine.invoices }
  describe 'instantiation' do
    it '::new' do

      expect(invoice_repository).to be_instance_of(InvoiceRepository)
    end
  end

  describe 'invoice repository methods' do
    it 'can return an array of all known invoice instances'do

    expect(invoice_repository.all).to eq(invoice_repository.invoices)
  end

    it 'create invoice' do
      invoice_1 = invoice_repository.create({
                                              :id => 1_234_567,
                                              :customer_id => 89_101_112,
                                              :merchant_id => 13_141_516,
                                              :created_at => Time.now.to_s,
                                              :status => 'pending',
                                              :updated_at => Time.now.to_s
                                            })

    expect(invoice_1).to be_instance_of(Invoice)
  end

    it 'finds invoice by id' do
      invoice_1 = invoice_repository.find_by_id(4986)

      expect(invoice_1.id).to eq(4986)
      expect(invoice_1.status).to eq(:pending)
    end

    it 'find all by customer_id' do
      invoice_1 = invoice_repository.find_by_id(4986)
      invoice_2 = invoice_repository.create({
                                              :customer_id => 89_101_112,
                                              :merchant_id => 13_141_516,
                                              :created_at => Time.now.to_s,
                                              :status => 'pending',
                                              :updated_at => Time.now.to_s
                                            })
      invoice_3 = invoice_repository.create({
                                              :customer_id => 89_101_112,
                                              :merchant_id => 19_876_543,
                                              :created_at => Time.now.to_s,
                                              :status => 'shipped',
                                              :updated_at => Time.now.to_s
                                            })

      expect(invoice_repository.find_all_by_customer_id(invoice_1.customer_id)).to eq([invoice_1, invoice_2, invoice_3])
    end

    it 'find all by merchant_id' do
      invoice_1 = invoice_repository.find_by_id(4986)
      invoice_2 = invoice_repository.find_by_id(4987)

      expect(invoice_repository.find_all_by_merchant_id(invoice_1.merchant_id)).to eq([invoice_1, invoice_2])
    end

    it 'find all by status' do
      invoice_1 = invoice_repository.create({
                                              :customer_id => 89_101_112,
                                              :merchant_id => 13_141_516,
                                              :created_at => Time.now.to_s,
                                              :status => 'pending',
                                              :updated_at => Time.now.to_s
                                            })

      expect(invoice_repository.find_all_by_status(invoice_1.status).size).to eq(1476)
    end

    it 'can update an invoice' do
      invoice_1 = invoice_repository.create({
                                              :customer_id => 89_101_112,
                                              :merchant_id => 13_141_516,
                                              :created_at => Time.now.to_s,
                                              :status => 'pending',
                                              :updated_at => Time.now.to_s
                                            })

      attributes = { status: 'shipped' }
      expected = invoice_repository.update(invoice_1.id, attributes)

      expect(expected.status).to eq('shipped')
    end

    it 'can delete invoice' do
      invoice_1 = invoice_repository.create({
                                              :customer_id => 89_101_112,
                                              :merchant_id => 13_141_516,
                                              :created_at => Time.now.to_s,
                                              :status => 'pending',
                                              :updated_at => Time.now.to_s
                                            })

      expect(invoice_repository.delete(invoice_1.id)).to eq(invoice_1)
      expect(invoice_repository.find_by_id(invoice_1.id)).to eq(nil)
    end

    it 'should #find_all_by_date' do
      expect(invoice_repository.find_all_by_date('2009-02-07').size).to eq 1
    end
  end
end
