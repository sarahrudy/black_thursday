require './lib/repository'
class MerchantRepository < Repository
  attr_reader :merchants
  def initialize(merchants)
    super(merchants)
    @merchants = merchants
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    merchant = Merchant.new(attributes)
    @merchants << merchant
    merchant
  end
end
