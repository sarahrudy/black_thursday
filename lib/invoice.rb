require 'time'

class Invoice
  attr_reader   :id,
                :customer_id,
                :merchant_id,
                :created_at,
                :transactions,
                :invoice_items
  attr_accessor :updated_at,
                :status

  def initialize(id:, customer_id:, merchant_id:, created_at:, status:, updated_at:)
    @id = id.to_i
    @customer_id = customer_id.to_i
    @merchant_id = merchant_id.to_i
    @created_at = Time.parse(created_at.to_s)
    @status = status.to_sym
    @updated_at = Time.parse(updated_at.to_s)
    @transactions = []
    @invoice_items = []
  end
  
  def add_transaction(transaction)
    @transactions << transaction
  end
  
  def add_invoice_item(invoice_item)
    @invoice_items << invoice_item
  end
end
