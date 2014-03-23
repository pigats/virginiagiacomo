class Amount

  attr_reader :value, :currency

  def initialize(amount, currency)
    @value = amount.to_i
    @currency = currency
    @@exchange_rate = { pound: 1, euro: 0.83, dollar: 0.60 }
  end



  def to_pound
    @value * @@exchange_rate[@currency.to_sym]
  end

end