require 'mongo'

class PiggyBank

  def initialize(db)
    @db = Mongo::Connection.new().db(db).collection('piggy-bank')
  end

  def deposit(from, amount)
    @db.insert({from: from, amount: amount}) unless amount < 0
  end

  def balance
    map = "function() { emit(1, this.amount); }"
    reduce = "function(key, values) { return Array.sum(values) }"
    options = {query: {}, out: {:inline => true}, raw: true }           
    @db.map_reduce(map, reduce, options)['results'].first['value']
  end

end