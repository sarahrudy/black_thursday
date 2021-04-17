require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'transaction_repository'

class SalesEngine
  attr_reader :item_path,
              :merchant_path,
              :invoice_path,
              :transaction_path

  def self.from_csv(file_paths)
    item_path = file_paths[:items]
    merchant_path = file_paths[:merchants]
    invoice_path = file_paths[:invoices]
    transaction_path = file_paths[:transactions]

    SalesEngine.new(item_path, merchant_path, invoice_path, transaction_path)
  end

  def initialize(item_path, merchant_path, invoice_path, transaction_path)
    @item_path = item_path
    @merchant_path = merchant_path
    @invoice_path = invoice_path
    @transaction_path = transaction_path
    @item_repository = ItemRepository.new(@item_path)
    @merchant_repository = MerchantRepository.new(@merchant_path)
    @invoice_repository = InvoiceRepository.new(@invoice_path)
    @transaction_repository = TransactionRepository.new(@transaction_path)
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

  def transactions
    @transaction_repository
  end
end
