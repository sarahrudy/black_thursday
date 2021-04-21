require 'time'

class Merchant
  attr_accessor :name
  attr_reader :id, :items, :created_at, :invoices
  attr_writer :updated_at

  def initialize(info)
    @id = info[:id].to_i
    @name = info[:name]
    @created_at = set_time(info[:created_at])
    @updated_at = set_time(info[:updated_at])
    @items = []
    @invoices = []
  end

  def set_time(time)
    if time
      Time.parse(time)
    else
      Time.now
    end
  end

  def add_item(item)
    @items << item
  end

  def add_invoice(invoice)
    @invoices << invoice
  end
end
