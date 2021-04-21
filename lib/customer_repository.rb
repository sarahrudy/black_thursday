require_relative 'repository'
require_relative 'customer'
require 'csv'

class CustomerRepository < Repository
  attr_reader :customers

  def initialize(file_path, engine)
    @customers = create_customers(file_path)
    @engine = engine
    super(@customers)
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    customer = Customer.new(attributes)
    @customers << customer
    customer
  end

  def create_customers(file_path)
    csv = CSV.read(file_path, :headers => true, :header_converters => :symbol)
    csv.map do |row|
      Customer.new(row)
    end
  end

  def find_all_by_first_name(first_name)
    @customers.find_all do |customer|
      customer_downcase = customer.first_name.downcase
      customer_downcase.include?(first_name.downcase)
    end
  end

  def find_all_by_last_name(last_name)
    @customers.find_all do |customer|
      customer_downcase = customer.last_name.downcase
      customer_downcase.include?(last_name.downcase)
    end
  end
end
