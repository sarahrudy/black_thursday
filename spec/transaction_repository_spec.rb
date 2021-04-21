require_relative 'spec_helper'

RSpec.describe TransactionRepository do
  describe 'instantiation' do
    it '::new' do
      transaction_repository = engine.transactions

      expect(transaction_repository).to be_instance_of(TransactionRepository)
    end
  end

  describe 'transaction repository methods' do
    it 'can return an array of all known transaction instances'do
      transaction_repository = engine.transactions

      expect(transaction_repository.all).to eq(transaction_repository.transactions)
    end

    it 'create transaction' do
      transaction_repository = engine.transactions
      transaction_1 = transaction_repository.create({
                                                      :id => 1_234_567,
                                                      :invoice_id => 8_901_011,
                                                      :credit_card_number => '1234567890123456',
                                                      :credit_card_expiration_date => '1221',
                                                      :result => :success,
                                                      :created_at => Time.now.to_s,
                                                      :updated_at => Time.now.to_s
                                                    })

      expect(transaction_1).to be_instance_of(Transaction)
    end

    it 'find transaction by id' do
      transaction_repository = engine.transactions
      transaction_1 = transaction_repository.create({
                                                      :invoice_id => 8_901_011,
                                                      :credit_card_number => '1234567890123456',
                                                      :credit_card_expiration_date => '1221',
                                                      :result => :success,
                                                      :created_at => Time.now.to_s,
                                                      :updated_at => Time.now.to_s
                                                    })

      expect(transaction_repository.find_by_id(transaction_1.id)).to eq(transaction_1)
    end

    it 'find all by invoice_id' do
      transaction_repository = engine.transactions
      transaction_1 = transaction_repository.find_by_id(4986)
      transaction_2 = transaction_repository.find_by_id(4987)
      transaction_3 = transaction_repository.create({
                                                      :invoice_id => 8_901_011,
                                                      :credit_card_number => '1234567890123456',
                                                      :credit_card_expiration_date => '1221',
                                                      :result => :success,
                                                      :created_at => Time.now.to_s,
                                                      :updated_at => Time.now.to_s
                                                    })

      expect(transaction_repository.find_all_by_invoice_id(transaction_1.invoice_id)).to eq([transaction_1,
                                                                                             transaction_2,
                                                                                             transaction_3])
    end

    it 'find all by credit_card_number' do
      transaction_repository = engine.transactions
      transaction_1 = transaction_repository.find_by_id(4986)
      transaction_2 = transaction_repository.find_by_id(4987)
      transaction_3 = transaction_repository.find_by_id(4988)

      expect(transaction_repository.find_all_by_credit_card_number(transaction_1.credit_card_number)).to eq([transaction_1,
                                                                                                             transaction_2,
                                                                                                             transaction_3])
    end

    it 'find all by result' do
      transaction_repository = engine.transactions
      transaction_1 = transaction_repository.create({
                                                      :invoice_id => 8_901_011,
                                                      :credit_card_number => '1234567890123456',
                                                      :credit_card_expiration_date => '1221',
                                                      :result => :success,
                                                      :created_at => Time.now.to_s,
                                                      :updated_at => Time.now.to_s
                                                    })
      transaction_2 = transaction_repository.create({
                                                      :invoice_id => 8_901_012,
                                                      :credit_card_number => '9876543210123456',
                                                      :credit_card_expiration_date => '1222',
                                                      :result => :failed,
                                                      :created_at => Time.now.to_s,
                                                      :updated_at => Time.now.to_s
                                                    })

      expect(transaction_repository.find_all_by_result(transaction_2.result).size).to eq(828)
    end

    it 'can update a transaction' do
      transaction_repository = engine.transactions
      transaction_1 = transaction_repository.create({
                                                      :invoice_id => 8_901_011,
                                                      :credit_card_number => '1234567890123456',
                                                      :credit_card_expiration_date => '1221',
                                                      :result => :success,
                                                      :created_at => Time.now.to_s,
                                                      :updated_at => Time.now.to_s
                                                    })

      attributes = {
                    credit_card_number: '9876543210123456',
                    credit_card_expiration_date: '1222'
                  }
      expected = transaction_repository.update(transaction_1.id, attributes)

      expect(expected.credit_card_number).to eq('9876543210123456')
    end

    it 'can delete a transaction' do
      transaction_repository = engine.transactions
      transaction_1 = transaction_repository.create({
                                                      :invoice_id => 8_901_011,
                                                      :credit_card_number => '1234567890123456',
                                                      :credit_card_expiration_date => '1221',
                                                      :result => :success,
                                                      :created_at => Time.now.to_s,
                                                      :updated_at => Time.now.to_s
                                                    })
      transaction_2 = transaction_repository.create({
                                                      :invoice_id => 8_901_012,
                                                      :credit_card_number => '9876543210123456',
                                                      :credit_card_expiration_date => '1222',
                                                      :result => :failed,
                                                      :created_at => Time.now.to_s,
                                                      :updated_at => Time.now.to_s
                                                    })

      expect(transaction_repository.delete(transaction_2.id)).to eq(transaction_2)
      expect(transaction_repository.find_by_id(transaction_2.id)).to eq(nil)
    end
  end
end
