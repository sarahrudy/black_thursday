# Black Thursday 

# It0 - Merchants & Items

The goal of this iteration is to get the ball rolling by focusing on a “Data Access Layer” for multiple CSV files.

## Data Access Layer

The idea of a *DAL* is to write classes which load and parse your raw data, allowing your system to then interact with rich ruby objects to do more complex analysis. In this iteration we’ll build the beginnings of a DAL by building the classes described below:

### `SalesEngine`

Then let’s tie everything together with one common root, a `SalesEngine` instance:

```ruby
se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv",
})
```

From there we can find the child instances:

- `items` returns an instance of `ItemRepository` with all the item instances loaded
- `merchants` returns an instance of `MerchantRepository` with all the merchant instances loaded

### `MerchantRepository`

The `MerchantRepository` is responsible for holding and searching our `Merchant` instances. It offers the following methods:

- `all` - returns an array of all known `Merchant` instances
- `find_by_id(id)` - returns either `nil` or an instance of `Merchant` with a matching ID
- `find_by_name(name)` - returns either `nil` or an instance of `Merchant` having done a *case insensitive* search
- `find_all_by_name(name)` - returns either `[]` or one or more matches which contain the supplied name fragment, *case insensitive*
- `create(attributes)` - create a new `Merchant` instance with the provided `attributes`. The new `Merchant`’s id should be the current highest `Merchant` id plus 1.
- `update(id, attributes)` - update the `Merchant` instance with the corresponding `id` with the provided `attributes`. Only the merchant’s `name` attribute can be updated.
- `delete(id)` - delete the `Merchant` instance with the corresponding `id`

The data can be found in `data/merchants.csv` so the instance is created and used like this:

```ruby
se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv",
})

mr = se.merchants
merchant = mr.find_by_name("CJsDecor")
# => <Merchant>
```

### `Merchant`

The merchant is one of the critical concepts in our data hierarchy.

- `id` - returns the integer id of the merchant
- `name` - returns the name of the merchant

We create an instance like this:

```ruby
m = Merchant.new({:id => 5, :name => "Turing School"})
```

### `ItemRepository`

The `ItemRepository` is responsible for holding and searching our `Item` instances. This object represents one line of data from the file `items.csv`.

It offers the following methods:

- `all` - returns an array of all known `Item` instances
- `find_by_id(id)` - returns either `nil` or an instance of `Item` with a matching ID
- `find_by_name(name)` - returns either `nil` or an instance of `Item` having done a *case insensitive* search
- `find_all_with_description(description)` - returns either `[]` or instances of `Item` where the supplied string appears in the item description (case insensitive)
- `find_all_by_price(price)` - returns either `[]` or instances of `Item` where the supplied price exactly matches
- `find_all_by_price_in_range(range)` - returns either `[]` or instances of `Item` where the supplied price is in the supplied range (a single Ruby `range` instance is passed in)
- `find_all_by_merchant_id(merchant_id)` - returns either `[]` or instances of `Item` where the supplied merchant ID matches that supplied
- `create(attributes)` - create a new `Item` instance with the provided `attributes`. The new `Item`’s id should be the current highest `Item` id plus 1.
- `update(id, attributes)` - update the `Item` instance with the corresponding `id` with the provided `attributes`. Only the item’s `name`, `desription`, and `unit_price` attributes can be updated. This method will also change the items `updated_at` attribute to the current time.
- `delete(id)` - delete the `Item` instance with the corresponding `id`

It’s initialized and used like this:

```ruby
se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv"
})

ir   = se.items
item = ir.find_by_name("Item Repellat Dolorum")
# => <Item>
```

### `Item`

The Item instance offers the following methods:

- `id` - returns the integer id of the item
- `name` - returns the name of the item
- `description` - returns the description of the item
- `unit_price` - returns the price of the item formatted as a `BigDecimal`
- `created_at` - returns a `Time` instance for the date the item was first created
- `updated_at` - returns a `Time` instance for the date the item was last modified
- `merchant_id` - returns the integer merchant id of the item

It also offers the following method:

- `unit_price_to_dollars` - returns the price of the item in dollars formatted as a `Float`

We create an instance like this:

```ruby
i = Item.new({
  :id          => 1,
  :name        => "Pencil",
  :description => "You can use it to write things",
  :unit_price  => BigDecimal.new(10.99,4),
  :created_at  => Time.now,
  :updated_at  => Time.now,
  :merchant_id => 2
})
```

-----------------------------------------------------------------

# It1 - Business Intelligence

## Starting the Analysis Layer

Our analysis will use the data to calculate information.

Who in the system will answer those questions? Assuming we have a `sales_engine` that’s an instance of `SalesEngine` let’s initialize a `SalesAnalyst` like this:

```ruby
sales_analyst = sales_engine.analyst
```



Then ask/answer these questions:

### How many products do merchants sell?

Do most of our merchants offer just a few items or do they represent a warehouse?

```ruby
sales_analyst.average_items_per_merchant # => 2.88
```

And what’s the standard deviation?

```ruby
sales_analyst.average_items_per_merchant_standard_deviation # => 3.26
```

### Note on Standard Deviations

There are two ways for calculating standard deviations – for a population and for a sample.

For this project, use the sample standard deviation.

As an example, given the set `3,4,5`. We would calculate the deviation using the following steps:

1. Take the difference between each number and the mean and square it
2. Sum these square differences together
3. Divide the sum by the number of elements minus 1
4. Take the square root of this result

Or, in pseudocode:

```ruby
set = [3,4,5]

std_dev = sqrt( ( (3-4)^2+(4-4)^2+(5-4)^2 ) / 2 )
```

### Which merchants sell the most items?

Maybe we could set a good example for our lower sellers by displaying the merchants who have the most items for sale. Which merchants are more than one standard deviation above the average number of products offered?

```ruby
sales_analyst.merchants_with_high_item_count # => [merchant, merchant, merchant]
```

### What are prices like on our platform?

Are these merchants selling commodity or luxury goods? Let’s find the average price of a merchant’s items (by supplying the merchant ID):

```ruby
sales_analyst.average_item_price_for_merchant(12334159) # => BigDecimal
```

Then we can sum all of the averages and find the average price across all merchants (this implies that each merchant’s average has equal weight in the calculation):

```ruby
sales_analyst.average_average_price_per_merchant # => BigDecimal
```

### Which are our *Golden Items*?

Given that our platform is going to charge merchants based on their sales, expensive items are extra exciting to us. Which are our “Golden Items”, those two standard-deviations above the average item price? Return the item objects of these “Golden Items”.

```ruby
sales_analyst.golden_items # => [<item>, <item>, <item>, <item>]
```

-----------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------

# It2: Basic Invoices

Now we’ll begin to move a little faster. Let’s work with invoices and build up the data access layer and business intelligence in one iteration.

## Data Access Layer

### `InvoiceRepository`

The `InvoiceRepository` is responsible for holding and searching our `Invoice` instances. It offers the following methods:

- `all` - returns an array of all known `Invoice` instances
- `find_by_id` - returns either `nil` or an instance of `Invoice` with a matching ID
- `find_all_by_customer_id` - returns either `[]` or one or more matches which have a matching customer ID
- `find_all_by_merchant_id` - returns either `[]` or one or more matches which have a matching merchant ID
- `find_all_by_status` - returns either `[]` or one or more matches which have a matching status
- `create(attributes)` - create a new `Invoice` instance with the provided `attributes`. The new `Invoice`’s id should be the current highest `Invoice` id plus 1.
- `update(id, attribute)` - update the `Invoice` instance with the corresponding `id` with the provided `attributes`. Only the invoice’s `status` can be updated. This method will also change the invoice’s updated_at attribute to the current time.
- `delete(id)` - delete the `Invoice` instance with the corresponding `id`

The data can be found in `data/invoices.csv` so the instance is created and used like this:

```ruby
se = SalesEngine.from_csv({:invoices => "./data/invoices.csv"})
invoice = se.invoices.find_by_id(6)
# => <invoice>
```

### `Invoice`

The invoice has the following data accessible:

- `id` - returns the integer id
- `customer_id` - returns the customer id
- `merchant_id` - returns the merchant id
- `status` - returns the status
- `created_at` - returns a `Time` instance for the date the item was first created
- `updated_at` - returns a `Time` instance for the date the item was last modified

We create an instance like this:

```ruby
i = Invoice.new({
  :id          => 6,
  :customer_id => 7,
  :merchant_id => 8,
  :status      => "pending",
  :created_at  => Time.now,
  :updated_at  => Time.now,
})
```

## Business Intelligence

Assuming we have a `sales_engine` that’s an instance of `SalesEngine` let’s initialize a `SalesAnalyst` like this:

```ruby
sales_analyst = sales_engine.analyst
```

### How many invoices does the average merchant have?

```ruby
sales_analyst.average_invoices_per_merchant # => 10.49
sales_analyst.average_invoices_per_merchant_standard_deviation # => 3.29
```

### Who are our top performing merchants?

Which merchants are more than two standard deviations *above* the mean?

```ruby
sales_analyst.top_merchants_by_invoice_count # => [merchant, merchant, merchant]
```

### Who are our lowest performing merchants?

Which merchants are more than two standard deviations *below* the mean?

```ruby
sales_analyst.bottom_merchants_by_invoice_count # => [merchant, merchant, merchant]
```

### Which days of the week see the most sales?

On which days are invoices created at more than one standard deviation *above* the mean?

```ruby
sales_analyst.top_days_by_invoice_count # => ["Sunday", "Saturday"]
```

### What percentage of invoices are not shipped?

What percentage of invoices are `shipped` vs `pending` vs `returned`? (takes symbol as argument)

```ruby
sales_analyst.invoice_status(:pending) # => 29.55
sales_analyst.invoice_status(:shipped) # => 56.95
sales_analyst.invoice_status(:returned) # => 13.5
```

----------------------------------------------------------------------

-----------------------------------------------------------------------------------------

# It3: Item Sales

We’ve got a good foundation, now it’s time to actually track the sale of items. There are three new data files to mix into the system, so for this iteration we’ll focus primarily on DAL with just a bit of Business Intelligence.

## Data Access Layer

### `InvoiceItemRepository`

Invoice items are how invoices are connected to items. A single invoice item connects a single item with a single invoice.

The `InvoiceItemRepository` is responsible for holding and searching our `InvoiceItem` instances. It offers the following methods:

- `all` - returns an array of all known `InvoiceItem` instances
- `find_by_id` - returns either `nil` or an instance of `InvoiceItem` with a matching ID
- `find_all_by_item_id` - returns either `[]` or one or more matches which have a matching item ID
- `find_all_by_invoice_id` - returns either `[]` or one or more matches which have a matching invoice ID
- `create(attributes)` - create a new `InvoiceItem` instance with the provided `attributes`. The new `InvoiceItem`’s id should be the current highest `InvoiceItem` id plus 1.
- `update(id, attribute)` - update the `InvoiceItem` instance with the corresponding `id` with the provided `attributes`. Only the invoice_item’s `quantity` and `unit_price` can be updated. This method will also change the invoice_item’s `updated_at` attribute to the current time.
- `delete(id)` - delete the `InvoiceItem` instance with the corresponding `id`

The data can be found in `data/invoice_items.csv` so the instance is created and used like this:

```ruby
sales_engine = SalesEngine.from_csv(:invoice_items => "./data/invoice_items.csv")
invoice_item = sales_engine.invoice_items.find_by_id(6)
# => <InvoiceItem>
```

### `InvoiceItem`

The invoice item has the following data accessible:

- `id` - returns the integer id
- `item_id` - returns the item id
- `invoice_id` - returns the invoice id
- `quantity` - returns the quantity
- `unit_price` - returns the unit_price
- `created_at` - returns a `Time` instance for the date the invoice item was first created
- `updated_at` - returns a `Time` instance for the date the invoice item was last modified

It also offers the following method:

- `unit_price_to_dollars` - returns the price of the invoice item in dollars formatted as a `Float`

We create an instance like this:

```ruby
ii = InvoiceItem.new({
  :id => 6,
  :item_id => 7,
  :invoice_id => 8,
  :quantity => 1,
  :unit_price => BigDecimal.new(10.99, 4),
  :created_at => Time.now,
  :updated_at => Time.now
})
```

### `TransactionRepository`

Transactions are billing records for an invoice. An invoice can have multiple transactions, but should have at most one that is successful.

The `TransactionRepository` is responsible for holding and searching our `Transaction` instances. It offers the following methods:

- `all` - returns an array of all known `Transaction` instances
- `find_by_id` - returns either `nil` or an instance of `Transaction` with a matching ID
- `find_all_by_invoice_id` - returns either `[]` or one or more matches which have a matching invoice ID
- `find_all_by_credit_card_number` - returns either `[]` or one or more matches which have a matching credit card number
- `find_all_by_result` - returns either `[]` or one or more matches which have a matching status
- `create(attributes)` - create a new `Transaction` instance with the provided `attributes`. The new `Transaction`’s id should be the current highest `Transaction` id plus 1.
- `update(id, attribute)` - update the `Transaction` instance with the corresponding `id` with the provided `attributes`. Only the transaction’s `credit_card_number`, `credit_card_expiration_date`, and `result` can be updated. This method will also change the transaction’s `updated_at` attribute to the current time.
- `delete(id)` - delete the `Transaction` instance with the corresponding `id`

The data can be found in `data/transactions.csv` so the instance is created and used like this:

```ruby
sales_engine = SalesEngine.from_csv(:transactions => "./data/transactions.csv")
transaction = sales_engine.transactions.find_by_id(6)
# => <Transaction>
```

### `Transaction`

The transaction has the following data accessible:

- `id` - returns the integer id
- `invoice_id` - returns the invoice id
- `credit_card_number` - returns the credit card number
- `credit_card_expiration_date` - returns the credit card expiration date
- `result` - the transaction result
- `created_at` - returns a `Time` instance for the date the transaction was first created
- `updated_at` - returns a `Time` instance for the date the transaction was last modified

We create an instance like this:

```ruby
t = Transaction.new({
  :id => 6,
  :invoice_id => 8,
  :credit_card_number => "4242424242424242",
  :credit_card_expiration_date => "0220",
  :result => "success",
  :created_at => Time.now,
  :updated_at => Time.now
})
```

### `CustomerRepository`

Customers represent a person who’s made one or more purchases in our system.

The `CustomerRepository` is responsible for holding and searching our `Customers` instances. It offers the following methods:

- `all` - returns an array of all known `Customers` instances
- `find_by_id` - returns either `nil` or an instance of `Customer` with a matching ID
- `find_all_by_first_name` - returns either `[]` or one or more matches which have a first name matching the substring fragment supplied
- `find_all_by_last_name` - returns either `[]` or one or more matches which have a last name matching the substring fragment supplied
- `create(attributes)` - create a new `Customer` instance with the provided `attributes`. The new `Customer`’s id should be the current highest `Customer` id plus 1.
- `update(id, attribute)` - update the `Customer` instance with the corresponding `id` with the provided `attributes`. Only the customer’s `first_name` and `last_name` can be updated. This method will also change the customer’s `updated_at` attribute to the current time.
- `delete(id)` - delete the `Customer` instance with the corresponding `id`

The data can be found in `data/customers.csv` so the instance is created and used like this:

```ruby
sales_engine = SalesEngine.from_csv(:customers => "./data/customers.csv")
customer = sales_engine.customers.find_by_id(6)
# => <Customer>
```

### `Customer`

The customer has the following data accessible:

- `id` - returns the integer id
- `first_name` - returns the first name
- `last_name` - returns the last name
- `created_at` - returns a `Time` instance for the date the customer was first created
- `updated_at` - returns a `Time` instance for the date the customer was last modified

We create an instance like this:

```ruby
c = Customer.new({
  :id => 6,
  :first_name => "Joan",
  :last_name => "Clarke",
  :created_at => Time.now,
  :updated_at => Time.now
})
```

## Business Intelligence

Assuming we have a `sales_engine` that’s an instance of `SalesEngine` let’s initialize a `SalesAnalyst` like this:

```ruby
sales_analyst = sales_engine.analyst
```

- `sales_analyst.invoice_paid_in_full?(invoice_id)` returns true if the `Invoice` with the corresponding id is paid in full
- `sales_analyst.invoice_total(invoice_id)` returns the total $ amount of the `Invoice` with the corresponding id.

**Notes:**

- Failed charges should never be counted in revenue totals or statistics.
- An invoice is considered paid in full if it has a successful transaction

----------------------------------------------------------------------------

-------------------------------------------------------------------

# It4: Merchant Analytics

Our operations team is asking for better data about of our merchants and have asked for the following:

Assuming we have a `sales_engine` that’s an instance of `SalesEngine` let’s initialize a `SalesAnalyst` like this:

```
sales_analyst = sales_engine.analyst
```

Find out the total revenue for a given date:

```ruby
sales_analyst.total_revenue_by_date(date) #=> $$
```

**Note:** When calculating revenue the `unit_price` listed within `invoice_items` should be used. The `invoice_item.unit_price` represents the final sale price of an item after sales, discounts or other intermediary price changes.

Find the top x performing merchants in terms of revenue:

```ruby
sales_analyst.top_revenue_earners(x) #=> [merchant, merchant, merchant, merchant, merchant]
```

If no number is given for `top_revenue_earners`, it takes the top 20 merchants by default:

```ruby
sales_analyst.top_revenue_earners #=> [merchant * 20]
```

Which merchants have pending invoices:

```ruby
sales_analyst.merchants_with_pending_invoices #=> [merchant, merchant, merchant]
```

**Note:** an invoice is considered pending if none of its transactions are successful.

Which merchants offer only one item:

```ruby
sales_analyst.merchants_with_only_one_item #=> [merchant, merchant, merchant]
```

And merchants that only sell one item by the month they registered (merchant.created_at):

```ruby
sales_analyst.merchants_with_only_one_item_registered_in_month("Month name") #=> [merchant, merchant, merchant]
```

Find the total revenue for a single merchant:

```ruby
sales_analyst.revenue_by_merchant(merchant_id) #=> $
```

# The following two methods are not covered by the spec harness. As a group, write a blog post of approximately 500 words as to how these methods work.

which item sold most in terms of quantity and revenue:

```ruby
sales_analyst.most_sold_item_for_merchant(merchant_id) #=> [item] (in terms of quantity sold) or, if there is a tie, [item, item, item]

sales_analyst.best_item_for_merchant(merchant_id) #=> item (in terms of revenue generated)
```

-----------------------------------------------------------------

-------------------------------------------------------------------

# It5: Customer Analytics

Our marketing team is asking for better data about of our customer base to launch a new project and have the following requirements:

Assuming we have a `sales_engine` that’s an instance of `SalesEngine` let’s initialize a `SalesAnalyst` like this:

```ruby
sales_analyst = sales_engine.analyst
```

Find the x customers that spent the most $:

```ruby
sales_analyst.top_buyers(x) #=> [customer, customer, customer, customer, customer]
```

If no number is given for `top_buyers`, it takes the top 20 customers by default

```ruby
sales_analyst.top_buyers #=> [customer * 20]
```

Be able to find which merchant the customers bought the most items from:

```ruby
sales_analyst.top_merchant_for_customer(customer_id) #=> merchant
```

Find which customers only have only one invoice:

```ruby
sales_analyst.one_time_buyers #=> [customer, customer, customer]
```

Find which item most `one_time_buyers` bought:

```ruby
sales_analyst.one_time_buyers_item #=> [item]
```

Find which items a given customer bought in given year (by the `created_at` on the related invoice):

```ruby
sales_analyst.items_bought_in_year(customer_id, year) #=> [item]
```

Return item(s) that customer bought in largest cumulative quantity. If there are several items with the same highest quantity, return all items:

```ruby
sales_analyst.highest_volume_items(customer_id) #=> [item] or [item, item, item]
```

Find customers with unpaid invoices:

```ruby
sales_analyst.customers_with_unpaid_invoices #=> [customer, customer, customer]
```

**Note:** invoices are unpaid if one or more of the invoices are not paid in full (see method `invoice#is_paid_in_full?`).

Find the best invoice, the invoice with the highest dollar amount:

```ruby
sales_analyst.best_invoice_by_revenue #=> invoice
sales_analyst.best_invoice_by_quantity #=> invoice
```