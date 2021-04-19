require_relative 'item_repository'
require_relative 'merchant_repository'
require_relative 'invoice_repository'
require_relative 'invoice_item_repository'
require_relative 'transaction_repository'
require_relative 'customer_repository'


class SalesEngine
  attr_reader :item_path,
              :merchant_path,
              :invoice_path,
              :invoice_item_path,
              :transaction_path,
              :customer_path

  def self.from_csv(file_paths)
    item_path = file_paths[:items]
    merchant_path = file_paths[:merchants]
    invoice_path = file_paths[:invoices]
    invoice_item_path = file_paths[:invoice_items]
    transaction_path = file_paths[:transactions]
    customer_path = file_paths[:customers]

    SalesEngine.new(item_path, merchant_path, invoice_path, invoice_item_path, transaction_path, customer_path)
  end

  def initialize(item_path, merchant_path, invoice_path, invoice_item_path, transaction_path, customer_path)
    @item_path = item_path
    @merchant_path = merchant_path
    @invoice_path = invoice_path
    @invoice_item_path = invoice_item_path
    @transaction_path = transaction_path
    @customer_path = customer_path
    @item_repository = ItemRepository.new(@item_path, self)
    @merchant_repository = MerchantRepository.new(@merchant_path, self)
    @invoice_repository = InvoiceRepository.new(@invoice_path, self)
    @invoice_item_repository = InvoiceItemRepository.new(@invoice_item_path, self)
    @transaction_repository = TransactionRepository.new(@transaction_path, self)
    @customer_repository = CustomerRepository.new(@customer_path, self)
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

  def invoice_items
    @invoice_item_repository
  end

  def transactions
    @transaction_repository
  end

  def customers
    @customer_repository
  end

  def analyst
    SalesAnalyst.new(self)
  end
end
