require_relative 'invoice_item_repository'
require 'csv'

class InvoiceItemRepository
  attr_reader :invoice_items

  def initialize(file_path)
    @invoice_items = create_invoice_items(file_path)
  end

  # def create(attributes)
  #   attributes[:id] = find_last_id.to_i + 1
  #   invoice_item = InvoiceItem.new(attributes)
  #   @invoice_items << invoice_item
  #   invoice  # returning instance of the invoice_item
  # end

  def create_invoice_items(file_path)
     csv = CSV.read(file_path, :headers => true, :header_converters => :symbol)
      csv.map do |row|
        InvoiceItem.new(row)
      end
  end
end