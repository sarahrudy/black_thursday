require_relative 'invoice'
require 'csv'

class InvoiceRepository
  attr_reader :invoices

  def initialize(file_path, engine)
    @engine = engine
    @invoices = create_invoices(file_path)
    populate_transactions
    populate_invoice_items
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

  def populate_transactions
    transaction_repo = @engine.transactions
    @invoices.each do |invoice|
      transaction_repo.all.each do |transaction|
        invoice.add_transaction(transaction) if invoice.id == transaction.invoice_id
      end
    end
  end
  def populate_invoice_items
    invoice_items = @engine.invoice_items.all
    @invoices.each do |invoice|
      invoice_items.each do |invoice_item|
        invoice.add_invoice_item(invoice_item) if invoice.id == invoice_item.invoice_id
      end
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

  def find_all_by_date(date)
    @invoices.find_all do |invoice|
      invoice.created_at.to_date == date
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
