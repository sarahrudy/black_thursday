require 'bigdecimal'
class Item
  attr_accessor :name,
                :description,
                :unit_price,
                :updated_at
  attr_reader :id,
              :merchant_id,
              :created_at
  def initialize(id:, name:, description:, unit_price:, created_at:, updated_at:, merchant_id:)
    @id = id.to_i
    @name = name
    @description = description
    @unit_price = BigDecimal(unit_price)
    @created_at = DateTime.parse(created_at)
    @updated_at = DateTime.parse(updated_at)
    @merchant_id = merchant_id.to_i
  end

  def unit_price=(price)
    @unit_price = BigDecimal(price)
  end

  def unit_price_to_dollars
    @unit_price.to_f
  end
end
