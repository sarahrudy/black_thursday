require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'

class SalesEngine
  attr_reader :item_path,
              :merchant_path,
              :invoice_path

  def self.from_csv(file_paths)
    item_path = file_paths[:items]
    merchant_path = file_paths[:merchants]
    invoice_path = file_paths[:invoices]

    SalesEngine.new(item_path, merchant_path, invoice_path)
  end

  def initialize(item_path, merchant_path, invoice_path)
    @item_path = item_path
    @merchant_path = merchant_path
    @invoice_path = invoice_path
    @item_repository = ItemRepository.new(@item_path)
    @merchant_repository = MerchantRepository.new(@merchant_path)
    @invoice_repository = InvoiceRepository.new(@invoice_path)
  end

  def items
    @item_repository
  end

  def merchants
    @merchant_repository
  end

  def invoices
    @invoice_repository
  end
end
