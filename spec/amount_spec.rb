require 'rspec'
require_relative '../amount'


describe Amount do 

  it 'has #value and #currency' do 
    a = Amount.new(200, 'pound')
    expect(a.value).to eq(200) 
    expect(a.currency).to eq('pound')
  end

  context 'currency converter' do 

    it 'converts dollars #to_pounds' do 
      a = Amount.new(1, 'dollar')
      expect(a.to_pound).to eq(0.60)
    end

    it 'converts euros #to_pounds' do 
      a = Amount.new(1, 'euro')
      expect(a.to_pound).to eq(0.83)
    end

  end

end