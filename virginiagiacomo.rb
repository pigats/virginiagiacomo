require 'compass'
require 'susy'
require 'haml'
require 'coffee-script'
require 'sinatra'
require 'sinatra/asset_pipeline'

class VirginiaGiacomo < Sinatra::Base

  register Sinatra::AssetPipeline


  get '/' do
    haml :index
  end

end