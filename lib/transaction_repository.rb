require_relative 'repository'
require_relative 'transaction'
require 'csv'

class TransactionRepository < Repository
  attr_reader :transactions

  def initialize(file_path, engine)
    @transactions = create_transactions(file_path)
    @engine = engine
    super(@transactions)
  end

  def create(attributes)
    attributes[:id] = find_last_id.to_i + 1
    transaction = Transaction.new(attributes)
    @transactions << transaction
    transaction
  end

  def create_transactions(file_path)
    csv = CSV.read(file_path, :headers => true, :header_converters => :symbol)
    csv.map do |row|
      Transaction.new(row)
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    @transactions.find_all do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    result = result.downcase.to_sym
    @transactions.find_all do |transaction|
      transaction.result.to_sym == result
    end
  end
end
