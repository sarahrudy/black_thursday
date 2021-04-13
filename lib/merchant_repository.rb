
class MerchantRepository
  attr_reader :merchants
  def initialize(merchants)
    @merchants = merchants
  end

  def all
    @merchants
  end

  def find_by_id(id)
    @merchants.find do |merchant|
      merchant.id == id
    end
  end

  def create(attributes)
    attributes[:id] = find_last_id + 1
    merchant = Merchant.new(attributes)
    @merchants << merchant
    merchant
  end

  def find_last_id
    merchants = @merchants.sort_by do |merchant|
      merchant.id
    end
    merchant = merchants.last
    merchant.id
  end
end
