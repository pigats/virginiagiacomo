require 'haml'
require './amount'

class Receipt

  def initialize deposit
    @deposit_id = deposit['_id']
    @path = "./tmp/#{@deposit_id}/receipt.pdf"
    print
  end

  def print
    `./bin/phantomjs-#{ENV['RACK_ENV']} ./lib/print.js #{@deposit_id} #{@path}`
  end

  def content
    File.read(@path)
  end

end
