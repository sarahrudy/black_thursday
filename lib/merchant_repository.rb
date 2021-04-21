require_relative 'repository'
require_relative 'merchant'
require 'csv'

class MerchantRepository < Repository
  attr_reader :merchants

  def initialize(file_path, engine)
    @engine = engine
    @merchants = create_merchants(file_path)
    populate_merchant_items
    populate_merchant_invoices
    super(@merchants)
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    merchant = Merchant.new(attributes)
    @merchants << merchant
    merchant
  end

  def create_merchants(file_path)
    csv = CSV.read(file_path, :headers => true, :header_converters => :symbol)
    csv.map do |row|
      Merchant.new(row)
    end
  end
  
  def populate_merchant_items
    items = @engine.items.all
    @merchants.each do |merchant|
      items.each do |item|
        merchant.add_item(item) if merchant.id == item.merchant_id
      end
    end
  end

  def populate_merchant_invoices
    invoices = @engine.invoices.all
    @merchants.each do |merchant|
      invoices.each do |invoice|
        merchant.add_invoice(invoice) if merchant.id == invoice.merchant_id
      end
    end
  end
end
