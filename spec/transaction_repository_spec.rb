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

  end
end
