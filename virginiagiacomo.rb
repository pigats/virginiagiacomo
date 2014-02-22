require 'compass'
require 'susy'
require 'haml'
require 'coffee-script'
require 'sinatra'
require 'sinatra/asset_pipeline'
require 'bson'

require './goals'
require './piggy_bank'

class VirginiaGiacomo < Sinatra::Base

  register Sinatra::AssetPipeline

  configure do
    db = 'virginiagiacomo'
    set :goal, Goal.new(db)
    set :piggy_bank, PiggyBank.new(db)
  end


  get '/' do
    
    balance = settings.piggy_bank.balance
    goals = settings.goal.all

    @goals_with_status = []

    goals.each do |goal|
    
      completed_fraction = case 
        when balance >= goal['value'] then 1
        when balance >= 0 then balance/goal['value'].to_f
        else  0
      end

      balance = balance - goal['value']

      @goals_with_status.push({ goal: goal, completed_fraction: completed_fraction })
      
    end

    @goals_with_status.to_json

    haml :index
  end


  # empty form
  get '/gifts/new' do 
    haml :'gifts/new'
  end

  # create gift
  post '/gifts' do
    id = settings.piggy_bank.deposit({name: params[:name], email: params[:email]}, params[:amount].to_i)
    redirect '/gifts/' + id.to_s
  end

  # show gift
  get '/gifts/:id' do 
    @gift = settings.piggy_bank.find_deposit(BSON::ObjectId(params[:id]))
    haml :'gifts/show'
  end


end