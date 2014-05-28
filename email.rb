require 'pony'

class EmailDevelopment
  def send_email(to_email, body, subject, attachment = nil)
    puts "Email sent to #{to_email}\nSubject: #{subject}\nBody: #{body}\n"
    puts "There's an attachment: #{attachment}" unless attachment.nil?
  end
end

class Email

  @@sendGridSMTP = {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }

  def send_email(to_email, body, subject, attachment = nil)
    
    opts = {
      :to => to_email,
      :from => 'giacomoandvirginia@gmail.com',
      :via => :smtp, 
      :via_options => @@sendGridSMTP,
      :subject => subject, 
      :body => body
    }
    opts[:attachments] = attachment unless attachment.nil? 
    
    Pony.mail opts

  end

end