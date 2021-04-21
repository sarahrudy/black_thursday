require_relative 'repository'
require_relative 'invoice_item'
require 'csv'

class InvoiceItemRepository < Repository
  attr_reader :invoice_items

  def initialize(file_path, engine)
    @invoice_items = create_invoice_items(file_path)
    @engine = engine
    super(@invoice_items)
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    invoice_item = InvoiceItem.new(attributes)
    @invoice_items << invoice_item
    invoice_item
  end

  def create_invoice_items(file_path)
    csv = CSV.read(file_path, :headers => true, :header_converters => :symbol)
    csv.map do |row|
      InvoiceItem.new(row)
    end
  end
end
