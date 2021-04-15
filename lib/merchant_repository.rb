require_relative 'merchant'
require 'csv'

class MerchantRepository
  attr_reader :merchants

  def initialize(file_path)
    @merchants = create_merchants(file_path)
    # parse_csv(file_path)
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

  def all
    @merchants
  end

  def find_by_id(id)
    @merchants.find do |merchant|
      merchant.id == id
    end
  end

  def find_by_name(name)
    @merchants.find do |merchant|
      merchant.name.casecmp?(name)
    end
  end

  def find_all_by_name(name)
    @merchants.find_all do |merchant|
      merchant_downcase = merchant.name.downcase
      merchant_downcase.include?(name.downcase)
    end
  end

  def update(id, attributes)
    merchant = find_by_id(id)
    return if !merchant
    attributes.each do |key,value|
      merchant.send("#{key.to_s}=", value) if merchant.respond_to?("#{key.to_s}=")
    end
    merchant.updated_at = Time.now
    merchant
  end

  def delete(id)
    merchant = find_by_id(id)
    @merchants.delete(merchant)
  end

  def find_last_id
    @merchants = @merchants.sort_by do |merchant|
      merchant.id.to_i
    end
    merchant = @merchants.last
    merchant.id
  end

  def inspect
  "#<#{self.class} #{@merchants.size} rows>"
end
end
