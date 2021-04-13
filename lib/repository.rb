class Repository
  def initialize(data)
    @data = data
  end

  def all
    @data
  end

  def find_by_id(id)
    @data.find do |data|
      data.id == id
    end
  end

  def find_by_name(name)
    # returns either nil or an instance of Item having done a case insensitive search
    name.downcase!
    @data.find do |data|
      data.name == name
    end
  end

  def delete(id)
    # delete the Item instance with the corresponding id
    item = find_by_id(id)
    @data.delete(item)
  end

  def update(id, attributes)
    # update the Item instance with the corresponding id with the provided attributes. Only the item’s name, desription, and unit_price attributes can be updated. This method will also change the items updated_at attribute to the current time.
    item = find_by_id(id)
    attributes.each do |key,value|
      item.send("#{key.to_s}=", value) if item.respond_to?("#{key.to_s}=")
    end
    item
  end

  private
  def find_last_id
    items = @data.sort_by do |data|
      data.id
    end
    item = items.last
    item.id
  end


end