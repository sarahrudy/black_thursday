require 'time'

class Transaction
  attr_reader   :id,
                :invoice_id,
                :created_at
  attr_accessor :credit_card_number,
                :credit_card_expiration_date,
                :result,
                :updated_at

  def initialize(id:, invoice_id:, created_at:, credit_card_number:, credit_card_expiration_date:, result:, updated_at:)
    @id = id.to_i
    @invoice_id = invoice_id.to_i
    @created_at = Time.parse(created_at.to_s)
    @credit_card_number = credit_card_number
    @credit_card_expiration_date = credit_card_expiration_date
    @result = result.to_sym
    @updated_at = Time.parse(updated_at.to_s)
  end
end
