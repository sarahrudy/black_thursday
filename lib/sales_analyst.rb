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
    merchants = @engine.merchants.all.sort { |a, b| b.items.size <=> a.items.size }
    cut_off = (merchants.size * 0.5).round
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
    prices = merchant.items.map { |item| item.unit_price }
    BigDecimal(prices.sum / prices.size, 5).round(2)
  end

  def average_average_price_per_merchant
    merchants = @engine.merchants.all
    total_average = []
    merchants.each do |merchant|
      total_average << average_item_price_for_merchant(merchant.id)
    end
    BigDecimal(total_average.sum / merchants.size, 5).round(2)
  end
  #     item_prices = []
  #     merchant.items.each do |item|
  #       item_prices << item.unit_price
  #     end
  #     total_average << item_prices.sum / item_prices.size
  #   end
  #   BigDecimal((total_average.sum / total_average.size), 5).round(2)
  # end

  # any item that is two standard deviations above the standard
  def golden_items
    item_price = @engine.items.all.map do |item|
      item.unit_price
    end
    golden = average(item_price) + (standard_deviation(item_price) * 2)
      @engine.items.all.find_all do |item|
        item.unit_price > golden
      end
  end

  def average(array)
    array.sum / array.size
  end
  # helper method for average_items_per_merchant_standard_deviation
  # an array
  def standard_deviation(sample_size)
    total_number_of_elements = sample_size.size
    mean = sample_size.sum / sample_size.size.to_r
    new_sample_size = sample_size.map do |ss|
      (ss - mean)**2
    end
    s = new_sample_size.sum / (total_number_of_elements - 1)
    Math.sqrt(s).round(2)
  end

 # gives you the invoice object
  def invoices_per_merchant
    merchants = @engine.merchants
    invoices = @engine.invoices

    merchants.all.map do |merchant|
      invoices.find_all_by_merchant_id(merchant.id).size
    end
  end

  # def invoices_count_per_merchant
  #   invoices_per_merchant.size
  # end

  def average_invoices_per_merchant
    (invoices_per_merchant.sum / invoices_per_merchant.size.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(invoices_per_merchant)
  end

  # def top_merchants_by_invoice_count
  #   two_deviations = average_invoices_per_merchant_standard_deviation +
  #     (average_items_per_merchant * 2)
  #   find_merchants = invoices_count_per_merchant.find_all do |count|
  #     @engine.merchants if count > two_deviations
  #   end
  #   find_merchants
  # end
end
