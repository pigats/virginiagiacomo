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

  configure :development do
    set :db, Mongo::Connection.new().db('virginiagiacomo')
  end

  configure :production do 
    set :db, Mongo::Connection.from_uri(ENV['MONGOLAB_URI']).db(URI.parse(ENV['MONGOLAB_URI']).path.gsub(/^\//, '')) 
  end

  configure do
    db = settings.db
    set :goal, Goal.new(db)
    set :piggy_bank, PiggyBank.new(db)
  end


  get '/' do
    
    balance = settings.piggy_bank.balance
    goals = settings.goal.all

    @completed_goals = []
    @next_goals = []

    goals.each do |goal|
    
      case 
        when balance >= goal['value'] then @completed_goals.push goal
        when balance >= 0 then 
          completed_fraction = balance/goal['value'].to_f
          @current_goal = goal.merge({ completed_fraction: completed_fraction })
        else  @next_goals.push goal
      end

      balance = balance - goal['value']
      
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