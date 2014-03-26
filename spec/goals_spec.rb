require 'rspec'
require_relative './spec_helper'
require_relative '../goal'

describe Goal do 

  it 'return #all goals ordered by sort field' do     
  
    db('goals')

    expect(@collection)
      .to receive(:find).with({})
      .and_return(@collection)

    expect(@collection)
      .to receive(:sort).with({sort: 1})

    goal = Goal.new(@db_connection)
    goal.all
  end

end