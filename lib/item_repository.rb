require_relative 'item'
require 'csv'

class ItemRepository
  attr_reader :items

  def initialize(file_path, engine)
    @engine = engine
    @items = create_items(file_path)
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    item = Item.new(attributes)
    @items << item
    item  # returning instance of the item
  end

  def create_items(file_path)
    csv = CSV.read(file_path, :headers => true, :header_converters => :symbol)
    csv.map do |row|
      Item.new(row)
    end
  end

  def find_all_with_description(description)
    # can refactor this to map enumerable
    item_array = []
    @items.each do |item|
      item_downcase = item.description.downcase
      item_array << item if item_downcase.include?(description.downcase)
    end
    item_array
  end

  def all
    @items
  end

  def find_by_id(id)
    @items.find do |data|
      data.id == id
    end
  end

  def find_by_name(name)
    @items.find do |data|
      data.name.casecmp?(name)
    end
  end

  def update(id, attributes)
    data = find_by_id(id)
    return unless data

    attributes.each do |key, value|
      data.send("#{key}=", value) if data.respond_to?("#{key}=")
    end
    data.updated_at = Time.now
    data
  end

  def delete(id)
    data = find_by_id(id)
    @items.delete(data)
  end

  def find_last_id
    @items = @items.sort_by do |data|
      data.id.to_i
    end
    data = @items.last
    data.id
  end

  def find_all_by_price(price)
    price = BigDecimal(price.to_i / 100.to_f, 5) unless price.instance_of?(BigDecimal)
    @items.find_all do |item|
      item.unit_price == price
    end
  end

  def find_all_by_price_in_range(range)
    @items.find_all do |item|
      range.cover?(item.unit_price)
    end
  end

  def find_all_by_merchant_id(merchant_id)
    @items.find_all do |item|
      item.merchant_id == merchant_id
    end
  end

  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end
end
