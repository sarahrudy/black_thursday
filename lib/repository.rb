# super class
class Repository
  def initialize(data_objects)
    @data_objects = data_objects
  end

  def all
    @data_objects
  end

  def find_by_id(id)
    @data_objects.find do |data|
      data.id == id
    end
  end

  def find_by_name(name)
    @data_objects.find do |data|
      data.name.casecmp?(name)
    end
  end

  def find_all_by_name(name)
    @data_objects.find_all do |data|
      data_downcase = data.name.downcase
      data_downcase.include?(name.downcase)
    end
  end

  def update(id, attributes)
    data = find_by_id(id)
    return unless data
    attributes.each do |key, value|
      data.send("#{key}=", value) if data.respond_to?("#{key}=")
    end
    data.updated_at = Time.now
    data
  end

  def delete(id)
    data = find_by_id(id)
    @data_objects.delete(data)
  end

  def find_all_by_date(date)
    date = Date.parse(date) if date.class != Date
    @data_objects.find_all do |data|
      data.created_at.to_date == date
    end
  end

  def find_all_by_customer_id(customer_id)
    @data_objects.find_all do |data|
      data.customer_id == customer_id
    end
  end

  def find_all_by_merchant_id(merchant_id)
    @data_objects.find_all do |data|
      data.merchant_id == merchant_id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @data_objects.find_all do |data|
      data.invoice_id == invoice_id
    end
  end

  def find_all_by_item_id(item_id)
    @data_objects.find_all do |data|
      data.item_id == item_id
    end
  end

  def inspect
    "#<#{self.class} #{@data_objects.size} rows>"
  end


  private # can't be accessed with their instance after the class

  def find_last_id
    data_objects = @data_objects.sort_by do |data|
      data.id.to_i
    end
    data = data_objects.last
    data.id
  end
end
