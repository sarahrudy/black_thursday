require_relative 'invoice'
require 'csv'

class InvoiceRepository
  attr_reader :invoices

  def initialize(file_path, engine)
    @invoices = create_invoices(file_path)
    @engine = engine
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    invoice = Invoice.new(attributes)
    @invoices << invoice
    invoice  # returning instance of the invoice
  end

  def create_invoices(file_path)
    csv = CSV.read(file_path, :headers => true, :header_converters => :symbol)
    csv.map do |row|
      Invoice.new(row)
    end
  end

  def all
    @invoices
  end

  def find_by_id(id)
    @invoices.find do |data|
      data.id == id
    end
  end

  def find_all_by_customer_id(customer_id)
    @invoices.find_all do |invoice|
      invoice.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    @invoices.find_all do |invoice|
      invoice.merchant_id == merchant_id
    end
  end

  def find_all_by_status(status)
    @invoices.find_all do |invoice|
      invoice.status == status
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
    @invoices.delete(data)
  end

  def find_last_id
    @invoices = @invoices.sort_by do |data|
      data.id.to_i
    end
    data = @invoices.last
    data.id
  end

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end
end
