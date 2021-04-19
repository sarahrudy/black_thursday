require 'pry'
require './lib/sales_engine'
require './lib/item'
require './lib/merchant'
require './spec/repository_spec/merchant_repository'

se = SalesEngine.from_csv({

                        items: './data/items.csv',
                        merchants: './data/merchants.csv',
                        invoices: './data/invoices.csv',
                        invoice_items: './data/invoice_items.csv',
                        transactions: './data/transactions.csv',
                        customers: './data/customers.csv',
                                     })




binding.pry
