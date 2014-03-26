require 'rspec'
require_relative '../currency_symbol'

describe String do 

  it 'converts currency strings #to_currency_symbol (html entities)' do 
    expect('euro'.to_currency_symbol).to eq('&euro;')
    expect('dollar'.to_currency_symbol).to eq('&dollar;')
    expect('pound'.to_currency_symbol).to eq('&pound;')
  end

end