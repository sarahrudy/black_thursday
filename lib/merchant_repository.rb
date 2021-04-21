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

  # helper method
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

  # def all
  #   @merchants
  # end

  # def find_by_id(id)
  #   @merchants.find do |merchant|
  #     merchant.id == id
  #   end
  # end

  # def find_by_name(name)
  #   @merchants.find do |merchant|
  #     merchant.name.casecmp?(name)
  #   end
  # end

  # def find_all_by_name(name)
  #   @merchants.find_all do |merchant|
  #     merchant_downcase = merchant.name.downcase
  #     merchant_downcase.include?(name.downcase)
  #   end
  # end

  # def update(id, attributes)
  #   merchant = find_by_id(id)
  #   return unless merchant
  #
  #   attributes.each do |key, value|
  #     merchant.send("#{key}=", value) if merchant.respond_to?("#{key}=")
  #   end
  #   merchant.updated_at = Time.now
  #   merchant
  # end

  # def delete(id)
  #   merchant = find_by_id(id)
  #   @merchants.delete(merchant)
  # end

  # def find_last_id
  #   merchants = @merchants.sort_by do |merchant|
  #     merchant.id.to_i
  #   end
  #   merchant = merchants.last
  #   if merchant
  #     merchant.id
  #   else
  #     0
  #   end
  # end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end
end
