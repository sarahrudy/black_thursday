require './lib/repository'
class ItemRepository < Repository
  attr_reader :items
  def initialize(items)
    super(items)
    @items = items
  end

  def create(attributes)
    attributes[:id] = find_last_id + 1
    item = Item.new(attributes)
    @data << item
    item
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
end