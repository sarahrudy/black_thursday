require_relative 'item_repository'
require_relative 'merchant_repository'

class SalesEngine
  attr_reader :item_path,
              :merchant_path

  def self.from_csv(file_paths)
    item_path = file_paths[:items]
    merchant_path = file_paths[:merchants]

    SalesEngine.new(item_path, merchant_path)
  end

  def initialize(item_path, merchant_path)
    @item_path = item_path
    @merchant_path = merchant_path
    @item_repository = ItemRepository.new(@item_path, self)
    @merchant_repository = MerchantRepository.new(@merchant_path, self)
  end

  def items
    @item_repository
  end

  def merchants
    @merchant_repository
  end

  def analyst
    SalesAnalyst.new(self)
  end
end
