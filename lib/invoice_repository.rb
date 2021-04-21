require_relative 'repository'
require_relative 'invoice'
require 'csv'

class InvoiceRepository < Repository
  attr_reader :invoices

  def initialize(file_path, engine)
    @engine = engine
    @invoices = create_invoices(file_path)
    populate_transactions
    populate_invoice_items
    super(@invoices)
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    invoice = Invoice.new(attributes)
    @invoices << invoice
    invoice
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

  def find_all_by_status(status)
    @invoices.find_all do |invoice|
      invoice.status == status
    end
  end
end
