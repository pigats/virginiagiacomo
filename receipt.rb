class Receipt

  def initialize deposit, locale
    id = deposit['_id']

    @url = "http://localhost:3000/honeymoon/contributions/#{id}/receipt"
    @path = "./pdfs/#{id}/receipt.pdf"
    @locale = locale
    
    print
  end

  def print
    `./bin/phantomjs-#{ENV['RACK_ENV']} ./lib/print.js #{@url} #{@path} #{@locale}`
  end

  def content
    File.read(@path)
  end

end
