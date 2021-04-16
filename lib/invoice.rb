require 'time'

class Invoice
  attr_reader   :id,
                :customer_id,
                :merchant_id,
                :created_at
  attr_accessor :updated_at,
                :status

  def initialize(id:, customer_id:, merchant_id:, created_at:, status:, updated_at:)
    @id = id.to_i
    @customer_id = customer_id.to_i
    @merchant_id = merchant_id.to_i
    @created_at = Time.parse(created_at.to_s)
    @status = status
    @updated_at = Time.parse(updated_at.to_s)
  end
end
