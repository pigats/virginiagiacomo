require 'rspec'
require 'rack/test'
require_relative '../virginiagiacomo'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() VirginiaGiacomo end
end

RSpec.configure { |c| c.include RSpecMixin }

describe VirginiaGiacomo do 

  it 'is up' do
    get '/'
    expect(last_response).to be_ok
  end

  context 'when browser language is italian' do

    let(:rack_env) { { 'HTTP_ACCEPT_LANGUAGE' => 'it' } }

    it 'return italian index' do
      get '/', {}, rack_env
      expect(last_response.body).to match 'matrimonio'
    end

    it 'return italian honeymoon' do
      get '/honeymoon', {}, rack_env
      expect(last_response.body).to match /luna.*di.*miele/i
    end

  end

  context 'when browser language is not italian' do 

    let(:rack_env) { { 'HTTP_ACCEPT_LANGUAGE' => 'de' } }

    it 'return english content' do
      get '/', {}, rack_env
      expect(last_response.body).to match 'wedding'
    end

    it 'return english content' do
      get '/honeymoon', {}, rack_env
      expect(last_response.body).to match /honeymoon/i
    end

  end




  context 'exposes RESTful contributions' do 

    it 'shows new contribution form' do 
      get '/honeymoon/contributions/new'
      expect(last_response).to be_ok
    end

    context 'when post-ed a new contribution' do

      it 'creates it if valid' do 
        params = {name: 'Mickey Mouse', email: 'mickeymouse@disney.com', amount: 1, currency: 'pound'}
        post '/honeymoon/contributions', params 
        expect(last_response).to be_redirect
        expect(last_response.location).to match /contributions\/\d+/        
      end

      it 'redirects to new if invalid' do 
        params = {name: '', email: 'mickeymouse@disney.com', amount: 1, currency: 'pound'}
        post '/honeymoon/contributions', params 
        expect(last_response).to be_redirect
        expect(last_response.location).to match /contributions\/new/        

      end

      it 'shows thanks for contribution' do 
        params = {name: 'Mickey Mouse', email: 'mickeymouse@disney.com', amount: 1, currency: 'pound'}
        post '/honeymoon/contributions', params 
        follow_redirect!
        expect(last_response.body).to match /thanks/i
        expect(last_response.body).to match /1.*&pound;/
      end

    end

  end


end