require './virginiagiacomo'
require './receipt'
require './amount'

namespace 'receipt' do 

  piggy_bank = VirginiaGiacomo.settings.piggy_bank

  desc 'Send receipt'
  task :send do 

    piggy_bank.all_deposits.each do |deposit|
      id = deposit['_id']
      unless piggy_bank.has_receipt_been_sent_for_deposit?(id)
        receipt = Receipt.new(deposit).print
        #piggy_bank.set_receipt_sent_for_deposit(id)
      end
    end
  end



end
