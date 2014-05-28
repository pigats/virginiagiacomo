require './virginiagiacomo'
require './receipt'
require './amount'

namespace 'receipt' do 

  piggy_bank = VirginiaGiacomo.settings.piggy_bank

  desc 'Send receipt'
  task :send do 
    piggy_bank.send_receipts
  end



end
