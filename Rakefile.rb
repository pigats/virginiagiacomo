Dir.glob('lib/*.rake').each { |r| import r }

require 'sinatra/asset_pipeline/task'
require './virginiagiacomo'

Sinatra::AssetPipeline::Task.define! VirginiaGiacomo

