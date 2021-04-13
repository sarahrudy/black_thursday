class Merchant
  attr_reader :id, :name
  attr_writer :name, :updated_at
  def initialize(id:, name:, created_at:, updated_at:)
    @id = id.to_i
    @name = name
    @created_at = DateTime.parse(created_at)
    @updated_at = DateTime.parse(updated_at)
  end
  # Add create method here
end
