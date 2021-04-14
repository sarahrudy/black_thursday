class Merchant
  attr_reader :id,
              :name
  attr_writer :name,
              :updated_at
  def initialize(info)
    @id = info[:id].to_i
    @name = info[:name]
    @created_at = set_time(info[:created_at])
    @updated_at = set_time(info[:updated_at])
  end
  # Add create method here

  def set_time(time)
    if time
      DateTime.parse(time)
    else 
      Time.now
    end
  end
end
