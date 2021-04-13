
class MerchantRepository
  attr_reader :merchants
  def initialize(merchants)
    @merchants = merchants
  end

  def all
    @merchants
  end
end

  def find_last_id
    merchants = @merchants.sort_by do |merchant|
      merchant.id
    end
    merchant = merchants.last
    merchant.id
  end
end
