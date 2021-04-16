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
end
