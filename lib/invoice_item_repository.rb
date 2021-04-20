require_relative 'invoice_item'
require 'csv'

class InvoiceItemRepository
  attr_reader :invoice_items

  def initialize(file_path, engine)
    @invoice_items = create_invoice_items(file_path)
    @engine = engine
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    invoice_item = InvoiceItem.new(attributes)
    @invoice_items << invoice_item
    invoice_item  # returning instance of the invoice_item
  end

  def create_invoice_items(file_path)
    csv = CSV.read(file_path, :headers => true, :header_converters => :symbol)
    csv.map do |row|
      InvoiceItem.new(row)
    end
  end

  def all
    @invoice_items
  end

  def find_by_id(id)
    @invoice_items.find do |data|
      data.id == id
    end
  end

  def find_all_by_item_id(item_id)
    @invoice_items.find_all do |invoice_item|
      invoice_item.item_id == item_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @invoice_items.find_all do |invoice_item|
      invoice_item.invoice_id == invoice_id
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
    @invoice_items.delete(data)
  end

  def find_last_id
    @invoice_items = @invoice_items.sort_by do |data|
      data.id.to_i
    end
    data = @invoice_items.last
    data.id
  end

  def inspect
    "#<#{self.class} #{@invoice_items.size} rows>"
  end
end
