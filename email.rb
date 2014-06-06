require 'pony'

class EmailDevelopment
 
  def send_email(to_email, subject, body, attachment = nil)

    puts "Email sent to #{to_email}\nSubject: #{subject}\nBody: #{body}\n"
    puts "There's an attachment" unless attachment.nil?
    
    true

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

  @@gmailSMTP = {
    :address              => 'smtp.gmail.com',
    :port                 => '587',
    :enable_starttls_auto => true,
    :user_name            => ENV['GMAIL_USERNAME'],
    :password             => ENV['GMAIL_PASSWORD'],
    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
    :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
  }

  def send_email(to_email, subject, body, attachment = nil) 
    
    opts = {
      :to => to_email,
      :from => 'giacomoandvirginia@gmail.com',
      :via => :smtp, 
      :via_options => @@gmailSMTP,
      :subject => subject, 
      :html_body => body
    }

    opts[:attachments] = attachment unless attachment.nil? 
    
    Pony.mail opts

    true

  end

end


