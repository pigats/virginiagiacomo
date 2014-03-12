class Amount 

  def initialize(amount, currency)
    @amount = amount.to_i
    @currency = currency
    @exchange_rate = { pound: 1, euro: 0.83, dollar: 0.60 }
  end

  def to_pound
    @amount * @exchange_rate[@currency.to_sym]
  end

end