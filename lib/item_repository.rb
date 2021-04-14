require './lib/repository'
class ItemRepository < Repository
  attr_reader :items
  def initialize(items)
    super(items)
    @items = items
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    item = Item.new(attributes)
    @items << item
    item  # returning instance of the item
  end

  def find_all_with_description(description)
    # can refactor this to map enumerable
    item_array = []
    @items.each do |item|
      item_downcase = item.description.downcase
      if item_downcase.include?(description.downcase)
        item_array << item
      end
    end
    item_array
  end

  def find_all_by_price(price)
    if !price.instance_of?(BigDecimal)
      price = BigDecimal(price)
    end
    @items.find_all do |item|
      item.unit_price == price
    end
  end
end
