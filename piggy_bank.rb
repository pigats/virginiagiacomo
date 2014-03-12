require 'mongo'

class PiggyBank

  def initialize(db)
    @db = db.collection('piggy-bank')
  end

  def deposit(from, amount)
    @db.insert({from: from, amount: amount}) unless amount[:value_in_pounds] <= 0
  end

  def balance
    map = "function() { emit(1, this.amount.value_in_pounds); }"
    reduce = "function(key, values) { return Array.sum(values) }"
    options = {query: {}, out: {:inline => true}, raw: true }           
    balance = @db.map_reduce(map, reduce, options)['results'].first
    balance = balance.nil? ? 0 : balance['value']
  end

  def find_deposit(id)
    @db.find_one({'_id' => id})
  end

end