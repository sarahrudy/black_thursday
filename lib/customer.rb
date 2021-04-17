require 'time'

class Customer
  attr_reader   :id,
                :created_at
  attr_accessor :first_name,
                :last_name,
                :updated_at

  def initialize(id:, first_name:, last_name:, created_at:, updated_at:)
    @id = id.to_i
    @first_name = first_name
    @last_name = last_name
    @created_at = Time.parse(created_at.to_s)
    @updated_at = Time.parse(updated_at.to_s)
  end
end
