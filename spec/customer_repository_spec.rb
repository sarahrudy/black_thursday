require 'spec_helper'

RSpec.describe CustomerRepository do
  before(:each) do
    @sales_engine = SalesEngine.from_csv({
                            items: './data/items.csv',
                            merchants: './data/merchants.csv',
                            invoices: './data/invoices.csv',
                            transactions: './data/transactions.csv',
                            customers: './data/customers.csv'
                         })
  end
  describe 'instantiation' do
    it "::new" do
      customer_repository = @sales_engine.customers

      expect(customer_repository).to be_instance_of(CustomerRepository)
    end
  end

  describe 'customer repository methods' do
    it 'can return an array of all known customer instances'do
      customer_repository = @sales_engine.customers

      # look into a different way of wording our test.
      expect(customer_repository.all).to eq(customer_repository.customers)
    end

  end
end
