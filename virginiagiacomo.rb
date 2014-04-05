require 'compass'
require 'susy'
require 'haml'
require 'coffee-script'
require 'sinatra'
require 'sinatra/asset_pipeline'
require 'bson'
require 'yaml'

require './goal'
require './amount'
require './piggy_bank'
require './currency_symbol'

class VirginiaGiacomo < Sinatra::Base

  register Sinatra::AssetPipeline
  enable :sessions

  configure :development do
    set :db, Mongo::Connection.new().db('virginiagiacomo')
  end

  configure :test do 
    set :db, Mongo::Connection.new().db('virginiagiacomo_test')
  end

  configure :production do 
    set :db, Mongo::Connection.from_uri(ENV['MONGOLAB_URI']).db(URI.parse(ENV['MONGOLAB_URI']).path.gsub(/^\//, '')) 
  end

  configure do
    db = settings.db
    set :goal, Goal.new(db)
    set :piggy_bank, PiggyBank.new(db)
    set :session_secret, ENV['SESSION_SECRET']
    set :it, YAML.load_file('./locales/it.yml')
    set :en, YAML.load_file('./locales/en.yml')
  end

  helpers do
    def t(key)
      return settings.send(@locale)[key]
    end 
  end

  before do
    @locale = request.env['HTTP_ACCEPT_LANGUAGE'].nil? || !request.env['HTTP_ACCEPT_LANGUAGE'].include?('it') ? 'en' : 'it'
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
  get '/honeymoon/contributions/new' do 
    @error = session[:gift_error] unless session[:gift_error].nil?
    haml :'contributions/new'
  end

  after '/honeymoon/contributions/new' do 
    session[:gift_error] = nil
  end

  # create gift
  post '/honeymoon/contributions' do    

    save = settings.piggy_bank.deposit(params.merge!(amount: Amount.new(params[:amount], params[:currency])))
    
    if save.equal?(false)
      session[:gift_error] = 'error_saving_contribution'
      redirect '/honeymoon/contributions/new'
    else
      redirect '/honeymoon/contributions/' + save.to_s
    end
  end

  # show gift
  get '/honeymoon/contributions/:id' do 
    @gift = settings.piggy_bank.find_deposit(BSON::ObjectId(params[:id]))
    haml :'contributions/show'
  end


  get '/receipt' do
    haml :receipt
  end

end