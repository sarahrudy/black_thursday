require_relative 'customer'
require 'csv'

class CustomerRepository
  attr_reader :customers

  def initialize(file_path, engine)
    @customers = create_customers(file_path)
    @engine = engine
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

  def update(id, attributes)
    data = find_by_id(id)
    return unless data

    attributes.each do |key, value|
      data.send("#{key}=", value) if data.respond_to?("#{key}=")
    end
    data.updated_at = Time.now
    data
  end

  def delete(id)
    data = find_by_id(id)
    @customers.delete(data)
  end

  def find_last_id
    @customers = @customers.sort_by do |data|
      data.id.to_i
    end
    data = @customers.last
    data.id
  end

  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end
end
