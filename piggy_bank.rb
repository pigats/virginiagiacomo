require 'mongo'
require 'pdfkit'
require './email'

class PiggyBank

  def initialize(db, email)
    @db = db.collection('piggy-bank')
    @email = email
  end

  def deposit(params)
    name = params[:name]
    email = params[:email]
    amount = params[:amount] 

    if(name.nil? or name.empty? or email.nil? or email.empty? or amount.nil? or amount.value <= 0) 
      return false 
    else 
      id = @db.insert({from: {name: name, email: email}, amount: {value: amount.value, currency: amount.currency, value_in_pounds: amount.to_pound}})
      send_notifications(name, email, amount)
      return id
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

  private
    def send_notifications(name, email, amount)
      send_email_to_us(name, email, amount)
    end

    def send_email_to_us(name, email, amount)
      body = "Hello!\n\nYour friend #{name} (#{email}), gave you #{amount.value} #{amount.currency} (£ #{amount.to_pound})."
      @email.send_email('giacomoandvirginia@gmail.com', body, 'New gift')
    end

    def send_receipt(name, email, amount)

    end


end