class Merchant
  attr_reader :id,
              :name
  attr_writer :name,
              :updated_at
  def initialize(info)
    @id = info[:id].to_i
    @name = info[:name]
    @created_at = DateTime.parse(info[:created_at])
    @updated_at = DateTime.parse(info[:updated_at])
  end
  # Add create method here
end
