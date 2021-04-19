require 'spec_helper'

RSpec.describe Customer do
  describe 'instantiation' do
    describe "::new" do
      it 'exists' do
        customer = Customer.new({
                        :id         => 1234567,
                        :first_name => "Zach",
                        :last_name  => "Green",
                        :created_at => Time.now.to_s,
                        :updated_at => Time.now.to_s
                      })

          expect(customer).to be_instance_of(Customer)
      end
    end
  end

end
