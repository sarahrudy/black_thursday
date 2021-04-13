class Item
  attr_reader :id,
              :name,
              :description,
              :unit_price,
              :created_at,
              :updated_at,
              :merchant_id
  def initialize(id:, name:, description:, unit_price:, created_at:, updated_at:, merchant_id:)
    @id = id.to_i
    @name = name
    @description = description
    @unit_price = unit_price
    @created_at = DateTime.parse(created_at)
    @updated_at = DateTime.parse(updated_at)
    @merchant_id = merchant_id.to_i
  end
end
