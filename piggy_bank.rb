require 'mongo'
require 'pdfkit'
require './email'
require './receipt'
require './virginiagiacomo'



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
      send_email_to_us(name, email, amount)
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

  def all_deposits 
    @db.find({})
  end

  def has_receipt_been_sent_for_deposit?(id)
    !find_deposit(id)['receipt_sent_at'].nil?
  end


  def unnotified_deposits
    @db.find({'receipt_sent_at' => nil})
  end

  def send_receipts
    unnotified_deposits.each do |deposit|
      send_receipt deposit 
    end
  end

  private

    def send_email_to_us(name, email, amount)
      body = "Hello!\n\nYour friend #{name} (#{email}), gave you #{amount.value} #{amount.currency} (£ #{amount.to_pound})."
      @email.send_email('giacomoandvirginia@gmail.com', 'New gift', body)
    end

    def send_receipt(deposit)
      
      locale = deposit['amount']['currency'].eql?('euro') ? 'it' : 'en'
      t = VirginiaGiacomo.settings.send(locale)
      subject = t['receipt_email_subject']
      body = '<h1>' + t['receipt_email_opening'] + ' ' + deposit['from']['name'] + '</h1>' + t['receipt_email_body']
  
      if @email.send_email(deposit['from']['email'], subject, body, {'thanks.pdf' => Receipt.new(deposit, locale).content})
        mark_deposit_as_sent deposit
      end
    end

    def mark_deposit_as_sent(deposit) 
      id = deposit['_id']
      @db.update({'_id' => id}, {'$set' => {'receipt_sent_at' => Time.now }})
    end


end