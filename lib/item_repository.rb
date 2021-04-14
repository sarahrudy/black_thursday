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
end
