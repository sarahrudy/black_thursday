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

  def find_by_name(name)
    # returns either nil or an instance of Item having done a case insensitive search
    name.downcase!
    @items.find do |item|
      item.name == name
    end
  end

  def find_all_with_description(description)
    # returns either [] or instances of Item where the supplied string appears in the item description (case insensitive)
  end

  def find_all_by_price(price)
    # returns either [] or instances of Item where the supplied price exactly matches
  end

  def find_all_by_price_in_range(range)
    # returns either [] or instances of Item where the supplied price is in the supplied range (a single Ruby range instance is passed in)
  end

  def find_all_by_merchant_id(merchant_id)
    # returns either [] or instances of Item where the supplied merchant ID matches that supplied
  end

  def update(id, attributes)
    # update the Item instance with the corresponding id with the provided attributes. Only the item’s name, desription, and unit_price attributes can be updated. This method will also change the items updated_at attribute to the current time.
  end

  def delete(id)
    # delete the Item instance with the corresponding id
    item = find_by_id(id)
    @items.delete(item)
  end

  private
  def find_last_id
    items = @items.sort_by do |item|
      item.id
    end
    item = items.last
    item.id
  end
end