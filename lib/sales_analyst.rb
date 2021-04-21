require 'time'
require 'date'
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
    #
    average_item_sd_height = average_items_per_merchant + average_items_per_merchant_standard_deviation

    short_list.find_all do |merchant|
      merchant.items.size > average_item_sd_height
    end
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = @engine.merchants.find_by_id(merchant_id)
    prices = merchant.items.map { |item| item.unit_price }
    return 0 if prices.size == 0

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

  def invoices_count_per_merchant
    invoices_per_merchant.size
  end

  def average_invoices_per_merchant
    (invoices_per_merchant.sum / invoices_per_merchant.size.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(invoices_per_merchant)
  end

  def top_merchants_by_invoice_count
    # iterate over merchants to see how many invoices they have
    # if that number is higher than the average + 2 st. dev.
    # return that value
    invoices = @engine.invoices
    golden_invoices = average_invoices_per_merchant + (average_invoices_per_merchant_standard_deviation * 2)
    @engine.merchants.all.find_all do |merchant|
      invoices.find_all_by_merchant_id(merchant.id).size > golden_invoices
    end
  end

  def bottom_merchants_by_invoice_count
    invoices = @engine.invoices
    golden_invoices = average_invoices_per_merchant - (average_invoices_per_merchant_standard_deviation * 2)
    @engine.merchants.all.find_all do |merchant|
      invoices.find_all_by_merchant_id(merchant.id).size < golden_invoices
    end
  end

  def top_days_by_invoice_count
    dow = { 0 => 'Sunday', 1 => 'Monday', 2 => 'Tuesday', 3 => 'Wednesday', 4 => 'Thursday', 5 => 'Friday',
            6 => 'Saturday' }
    # days with highest number of sales by invoice count
    invoice_repo = @engine.invoices
    average_per_day = invoice_repo.all.size / 7
    # grouped_invoices = Hash.new{|h,k| h[k] = 0}
    grouped_invoices = Hash.new(0)
    invoice_repo.all.each do |invoice|
      d = invoice.created_at.wday
      grouped_invoices[dow[d]] += 1
    end
    golden = average_per_day + standard_deviation(grouped_invoices.values)
    grouped_invoices.find_all do |wday, invoice_count|
      grouped_invoices.delete(wday) if invoice_count < golden
    end
    grouped_invoices.keys
  end

  def invoice_status(status)
    invoices = @engine.invoices
    ((invoices.find_all_by_status(status).size / invoices.all.size.to_f) * 100).round(2)
  end

  def invoice_paid_in_full?(invoice_id)
    # return true if transaction result is success
    transactions = @engine.transactions.find_all_by_invoice_id(invoice_id)
    return false if transactions.empty?
    
    transactions.all? do |transaction|
      transaction.result == :success
    end
  end

  def invoice_total(invoice_id)
    invoice_items_repo = @engine.invoice_items
    invoice_item = invoice_items_repo.find_all_by_invoice_id(invoice_id)
    invoice_item.sum do |item|
      item.quantity * item.unit_price
    end
  end

  def total_revenue_by_date(date) # not passing test
    date = get_date(date)
    transactions_repo = @engine.transactions
    invoices = @engine.invoices.find_all_by_date(date)

    arr = []
    invoices.each do |invoice|
      invoice.invoice_items.each do |invoice_item|
        arr << invoice_item
      end
    end

    total = arr.sum do |ii|
      ii.unit_price * ii.quantity
    end
    BigDecimal(total, 8)
  end

  def revenue_by_merchant(merchant_id)
    invo_repo = @engine.invoices
    invo_item_repo = @engine.invoice_items
    invoices = invo_repo.find_all_by_merchant_id(merchant_id)

    invoices_paid_in_full = invoices.find_all { |invoice| invoice_paid_in_full?(invoice.id) }

    total = 0
    invoices_paid_in_full.each do |invoice|
      invo_items = invo_item_repo.find_all_by_invoice_id(invoice.id)
      total += invo_items.sum do |ii|
        ii.unit_price * ii.quantity
      end
    end
    total
  end

  def top_revenue_earners(num_of_merchants = 20)
    merchants = @engine.merchants.all
    # invoice_repo = @engine.invoices
    transactions_repo = @engine.transactions
    merchant_revenue  = merchants.map do |merchant|
      [merchant, revenue_by_merchant(merchant.id)]
    end

    sorted_merchant_revenue = merchant_revenue.sort do |a,b|
      b[1] <=> a[1]
    end

    sorted_merchant_revenue[0..(num_of_merchants - 1)].map do |merch_rev_elem|
      merch_rev_elem[0]
    end
  end

  def merchants_with_pending_invoices # not passing test
    merchants = @engine.merchants.all
    merchants_array = []
    merchants.each do |merchant|
      merchant.invoices.each do |invoice|
        all_transactions_failed = invoice.transactions.all? do |transaction|
          transaction.result == :failed
        end
        if all_transactions_failed
          merchants_array << merchant
        end
      end
    end
    merchants_array.flatten.uniq
  end
  
  def merchants_with_only_one_item
    @engine.merchants.all.find_all do |merchant|
      merchant.items.size == 1 
    end
  end

  def merchants_with_only_one_item_registered_in_month(month)
    months = {
      1  =>'january',
      2  =>'february',
      3  =>'march',
      4  =>'april',
      5  =>'may',
      6  =>'june',
      7  =>'july',
      8  =>'august',
      9  =>'september',
      10 =>'october',
      11 =>'november',
      12 =>'december'}
    merchants = @engine.merchants.all.find_all do |merchant|
      month_digit = merchant.created_at.to_date.month
      months[month_digit] == month.downcase
    end
    merchants.find_all do |merchant|
      merchant.items.size == 1
    end
  end

  def get_date(date)
    if date.class == String
      date = Date.parse(date)
    elsif date.class == Time
      date = date.to_date
    end
  end
end
