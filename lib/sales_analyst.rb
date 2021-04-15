class SalesAnalyst
  def initialize(engine)
    @engine = engine
  end

  def average_items_per_merchant
    merchants = @engine.merchants
    items = @engine.items
    arr = []

    merchants.all.each do |merchant|
      arr << items.find_all_by_merchant_id(merchant.id).size
    end
    (arr.sum / arr.size.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation

  end

  def merchants_with_high_item_count

  end

  def average_item_price_for_merchant(merchant_id)

  end

  def average_average_price_per_merchant

  end

  def golden_items

  end
end
