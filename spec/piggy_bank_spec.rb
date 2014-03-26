require 'rspec'
require_relative './spec_helper'
require_relative '../piggy_bank'

describe PiggyBank do 

  before :each do
    db('piggy-bank')
    @piggy_bank = PiggyBank.new(@db_connection)
  end


  context 'validate a #deposit and' do

    before :each do 
      amount = double('amount')
      allow(amount).to receive(:value).and_return(1)
      allow(amount).to receive(:currency).and_return('pound')
      allow(amount).to receive(:to_pound).and_return(1)
      @params = {name: 'Mickey Mouse', email: 'mickeymouse@disney.com', amount: amount}
    end

    it 'saves it when valid' do 
      expect(@collection).to receive(:insert)
        .with({from: {name: 'Mickey Mouse', email: 'mickeymouse@disney.com'}, amount: {value: 1, currency: 'pound', value_in_pounds: 1}})

      @piggy_bank.deposit(@params)
    end

    it 'return false if name is missing' do 
      @params.delete(:name)
      expect(@piggy_bank.deposit(@params)).to be false
    end

    it 'return false if name is empty' do 
      @params[:name] = ''
      expect(@piggy_bank.deposit(@params)).to be false
    end

    it 'return false if email is missing' do 
      @params.delete(:email)
      expect(@piggy_bank.deposit(@params)).to be false
    end

    it 'return false if email is empty' do 
      @params[:email] = ''
      expect(@piggy_bank.deposit(@params)).to be false
    end

    it 'return false if amount is missing' do 
      @params.delete(:amount)
      expect(@piggy_bank.deposit(@params)).to be false
    end

    it 'return false if amount is <= 0' do 
      amount = double('amount')
      allow(amount).to receive(:new).and_return(amount)
      allow(amount).to receive(:value).and_return(0)
      @params[:amount] = amount
      expect(@piggy_bank.deposit(@params)).to be false 
      
      allow(amount).to receive(:value).and_return(-1)
      @params[:amount] = amount
      expect(@piggy_bank.deposit(@params)).to be false      
    end

  end

  it '#find_deposit by id' do 
    expect(@collection).to receive(:find_one)
      .with({'_id' => 1})

    @piggy_bank.find_deposit(1)
  end

  it 'return the #balance' do 
    expect(@collection)
      .to receive(:map_reduce)
      .with(/value_in_pounds/, /Array.sum/, an_instance_of(Hash))
      .and_return({'results' => [{'value' => 10}]})
    
    expect(@piggy_bank.balance).to eq(10)      
  end 

end