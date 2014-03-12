require 'compass'
require 'susy'
require 'haml'
require 'coffee-script'
require 'sinatra'
require 'sinatra/asset_pipeline'
require 'bson'
require 'yaml'

require './goals'
require './amount'
require './piggy_bank'
require './currency_symbol'

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
    set :it, YAML.load_file('./locales/it.yml')
    set :en, YAML.load_file('./locales/en.yml')
  end

  helpers do
    def t(key)
      return settings.send(@locale)[key]
    end 
  end

  before do
    @locale = request.env['HTTP_ACCEPT_LANGUAGE'].include?('it-IT') ? 'it' : 'en'
  end

  get '/' do
    haml :index
  end

  get '/honeymoon' do
    
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

    haml :goals
  end


  # empty form
  get '/honeymoon/gifts/new' do 
    haml :'gifts/new'
  end

  # create gift
  post '/honeymoon/gifts' do
    value = params[:amount]
    currency = params[:currency]

    amount = { value_original: value, currency: currency, value_in_pounds: Amount.new(value, currency).to_pound }
    
    id = settings.piggy_bank.deposit({name: params[:name], email: params[:email]}, amount)
    redirect '/honeymoon/gifts/' + id.to_s
  end

  # show gift
  get '/honeymoon/gifts/:id' do 
    @gift = settings.piggy_bank.find_deposit(BSON::ObjectId(params[:id]))
    haml :'gifts/show'
  end


end