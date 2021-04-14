require 'bigdecimal'
class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id
  def initialize(id:, name:, description:, unit_price:, created_at:, updated_at:, merchant_id:)
    @id = id
    @name = name
    @description = description
    @unit_price = BigDecimal(unit_price)
    @created_at = DateTime.parse(created_at) # parse takes a string so we have to give it a string
    @updated_at = DateTime.parse(updated_at)
    @merchant_id = merchant_id
  end
end
