class String
  
  def to_currency_symbol 
    case self
      when 'euro'   then '&euro;'
      when 'dollar' then '&dollar;'
      when 'pound'  then '&pound;'
      else self
    end
  end

end