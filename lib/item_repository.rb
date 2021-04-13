class ItemRepository
  def initialize(items)
    @items = items
  end

  def create(attributes)
    attributes[:id] = find_last_id + 1
    item = Item.new(attributes)
    @items << item
    item
  end

  def find_by_id(id)
    @items.find do |item|
      item.id == id
    end
  end


  def find_last_id
    items = @items.sort_by do |item|
      item.id
    end
    item = items.last
    item.id
  end
end