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
end
