require 'mongo'
require 'pdfkit'

require './amount'

class PiggyBank

  def initialize(db)
    @db = db.collection('piggy-bank')

  end

  def deposit(params)
    name = params[:name]
    email = params[:email]
    amount = Amount.new(params[:amount], params[:currency])

    if(name.empty? or email.empty? or amount.value <= 0) 
      return false 
    else 
      @db.insert({from: {name: name, email: email}, amount: {value: amount.value, currency: amount.currency, value_in_pounds: amount.to_pound}})
    end
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

  def print_receipt(id)
    deposit = find_deposit(id)
  end

  def send_receipt(id)

  end



end