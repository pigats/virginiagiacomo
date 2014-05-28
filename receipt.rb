require 'haml'
require './amount'

class Receipt

  def initialize deposit
    @deposit_id = deposit['_id']
  end

  def print
    `./bin/phantomjs-#{ENV['RACK_ENV']} ./lib/print.js #{@deposit_id}`
  end

end
