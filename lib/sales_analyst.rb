class SalesAnalyst
  def initialize(engine)
    @engine = engine
  end

  def items_per_merchant
    merchants = @engine.merchants
    items = @engine.items

    merchants.all.map do |merchant|
      items.find_all_by_merchant_id(merchant.id).size
    end
  end

  def average_items_per_merchant
    ipm = items_per_merchant
    (ipm.sum / ipm.size.to_f).round(2)
  end

  def average_items_per_merchant_standard_deviation
    ipm = items_per_merchant
    standard_deviation(ipm)
  end

  def merchants_with_high_item_count
    merchants = @engine.merchants.all.sort {|a,b| b.items.size <=> a.items.size}
    cut_off = (merchants.size * 0.1).round
    short_list = merchants[0..cut_off]
    # average = average_items_per_merchant
    # merchants_filtered = @engine.merchants.all.select do |merchant|
    #   merchant.items.size > average
    # end

    w = short_list.find_all do |merchant|
      # require "pry"; binding.pry
      merchant.items.size > (average_items_per_merchant + average_items_per_merchant_standard_deviation)
    end
    # require "pry"; binding.pry
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = @engine.merchants.find_by_id(merchant_id)
    prices = merchant.items.map {|item| item.unit_price}
    BigDecimal(prices.sum / prices.size, 5).round(2)
  end

  def average_average_price_per_merchant
    merchants = @engine.merchants.all
    total_average = []
    merchants.each do |merchant|
      item_prices = []
      merchant.items.each do |item|
        item_prices << item.unit_price
      end
      total_average << item_prices.sum / item_prices.size
    end
    BigDecimal((total_average.sum / total_average.size), 5).round(2)
  end

  def golden_items

  end

# helper method for average_items_per_merchant_standard_deviation

  def standard_deviation(sample_size) # an array
    total_number_of_elements = sample_size.size
    mean = sample_size.sum/sample_size.size.to_r
    new_sample_size = sample_size.map do |ss|
      (ss - mean)**2
    end
    s = new_sample_size.sum/(total_number_of_elements -1)
    Math.sqrt(s).round(2)

  end
end
