require 'bigdecimal'
require 'time'

class Item
  attr_reader   :id,
                :created_at,
                :merchant_id
  attr_accessor :name,
                :description,
                :unit_price,
                :updated_at

  def initialize(id:, name:, description:, unit_price:, created_at:, updated_at:, merchant_id:)
    @id = id.to_i
    @name = name
    @description = description
    @unit_price = BigDecimal((unit_price.to_i / 100.to_f), 4)
    @created_at = Time.parse(created_at.to_s) # parse takes a string so we have to give it a string
    @updated_at = Time.parse(updated_at.to_s)
    @merchant_id = merchant_id.to_i
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end
end
