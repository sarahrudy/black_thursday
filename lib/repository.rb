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
  end

  def update(id, attributes)
  end

  def delete(id)
  end

private # can't be accessed with their instance after the class

  def find_last_id
    data_objects = @data_objects.sort_by do |data|
      data.id
    end
    data = data_objects.last
    data.id
  end
end
