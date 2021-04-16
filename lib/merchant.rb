require 'time'

class Merchant
  attr_reader :id,
              :name,
              :items
  attr_writer :name,
              :updated_at
  def initialize(info)
    @id = info[:id].to_i
    @name = info[:name]
    @created_at = set_time(info[:created_at])
    @updated_at = set_time(info[:updated_at])
    @items = []
  end
  # Add create method here

  def set_time(time)
    if time
      Time.parse(time)
    else
      Time.now
    end
  end

  def add_item(item)
    @items << item
  end


end
