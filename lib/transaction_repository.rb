require_relative 'transaction'
require 'csv'

class TransactionRepository
  attr_reader :transactions

  def initialize(file_path)
    @transactions = create_transactions(file_path)
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    transaction = Transaction.new(attributes)
    @transactions << transaction
    transaction  # returning instance of the transaction
  end

  def create_transactions(file_path)
     csv = CSV.read(file_path, :headers => true, :header_converters => :symbol)
      csv.map do |row|
        Transaction.new(row)
      end
  end

  def all
    @transactions
  end

  def find_by_id(id)
    @transactions.find do |data|
      data.id == id
    end
  end

  def find_all_by_invoice_id(invoice_id)
    @transactions.find_all do |transaction|
      transaction.invoice_id == invoice_id
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    @transactions.find_all do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    @transactions.find_all do |transaction|
      transaction.result == result
    end
  end

  def update(id, attributes)
    data = find_by_id(id)
    return if !data
    attributes.each do |key,value|
      data.send("#{key.to_s}=", value) if data.respond_to?("#{key.to_s}=")
    end
    data.updated_at = Time.now
    data
  end

  def delete(id)
    data = find_by_id(id)
    @transactions.delete(data)
  end

  def find_last_id
    @transactions = @transactions.sort_by do |data|
      data.id.to_i
    end
    data = @transactions.last
    data.id
  end

  def inspect
  "#<#{self.class} #{@items.size} rows>"
  end
end
