require 'spec_helper'

RSpec.describe TransactionRepository do
  before(:each) do
    @sales_engine = SalesEngine.from_csv({
                            items: './data/items.csv',
                            merchants: './data/merchants.csv',
                            invoices: './data/invoices.csv',
                            transactions: './data/transactions.csv'
                         })
  end
  describe 'instantiation' do
    it "::new" do
      transaction_repository = @sales_engine.transactions

      expect(transaction_repository).to be_instance_of(TransactionRepository)
    end
  end

  describe 'transaction repository methods' do
    it 'can return an array of all known transaction instances'do
      transaction_repository = @sales_engine.transactions

      # look into a different way of wording our test.
      expect(transaction_repository.all).to eq(transaction_repository.transactions)
    end

    it 'create transaction' do
      transaction_repository = @sales_engine.transactions
      transaction_1 = transaction_repository.create({
                      :id                           => 1234567,
                      :invoice_id                   => 8901011,
                      :credit_card_number           => '1234567890123456',
                      :credit_card_expiration_date  => '1221',
                      :result                       => 'success',
                      :created_at                   => Time.now.to_s,
                      :updated_at                   => Time.now.to_s
                    })

      expect(transaction_1).to be_instance_of(Transaction)
    end

    it 'find transaction by id' do
      transaction_repository = @sales_engine.transactions
      transaction_1 = transaction_repository.create({
                      :invoice_id                   => 8901011,
                      :credit_card_number           => '1234567890123456',
                      :credit_card_expiration_date  => '1221',
                      :result                       => 'success',
                      :created_at                   => Time.now.to_s,
                      :updated_at                   => Time.now.to_s
                    })

      expect(transaction_repository.find_by_id(transaction_1.id)).to eq(transaction_1)
    end
  end
end
