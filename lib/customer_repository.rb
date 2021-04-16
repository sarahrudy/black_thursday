require_relative 'customer'
require 'csv'

class CustomerRepository
  attr_reader :customers

  def initialize(file_path)
    @customers = create_customers(file_path)
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    customer = Customer.new(attributes)
    @customers << customer
    customer  # returning instance of the customer
  end

  def create_customers(file_path)
     csv = CSV.read(file_path, :headers => true, :header_converters => :symbol)
      csv.map do |row|
        Customer.new(row)
      end
  end

  def all
    @customers
  end

  def find_by_id(id)
    @customers.find do |data|
      data.id == id
    end
  end

  # def find_all_by_invoice_id(invoice_id)
  #   @transactions.find_all do |transaction|
  #     transaction.invoice_id == invoice_id
  #   end
  # end
  #
  # def find_all_by_credit_card_number(credit_card_number)
  #   @transactions.find_all do |transaction|
  #     transaction.credit_card_number == credit_card_number
  #   end
  # end
  #
  # def find_all_by_result(result)
  #   @transactions.find_all do |transaction|
  #     transaction.result == result
  #   end
  # end
  #
  # def update(id, attributes)
  #   data = find_by_id(id)
  #   return if !data
  #   attributes.each do |key,value|
  #     data.send("#{key.to_s}=", value) if data.respond_to?("#{key.to_s}=")
  #   end
  #   data.updated_at = Time.now
  #   data
  # end
  #
  # def delete(id)
  #   data = find_by_id(id)
  #   @transactions.delete(data)
  # end
  #
  def find_last_id
    @customers = @customers.sort_by do |data|
      data.id.to_i
    end
    data = @customers.last
    data.id
  end

  # def inspect
  # "#<#{self.class} #{@items.size} rows>"
  # end
end
