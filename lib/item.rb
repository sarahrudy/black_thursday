class Item
  def initialize(id:, name:, description:, unit_price:, created_at:, updated_at:, merchant_id:)
    @id = id
    @name = name
    @description = description
    @unit_price = unit_price
    @created_at = DateTime.parse(created_at)
    @updated_at = DateTime.parse(updated_at)
    @merchant_id = merchant_id
  end
end
