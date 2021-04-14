class Repository # super class

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
      data.name.casecmp?(name)
    end
  end

  def update(id, attributes)
    data = find_by_id(id)
    attributes.each do |key,value|
      data.send("#{key.to_s}=", value) if data.respond_to?("#{key.to_s}=")
    end
    data.updated_at = DateTime.now
    data
  end

  def delete(id)
    data = find_by_id(id)
    @data_objects.delete(data)
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
