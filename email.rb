require 'pony'

class EmailDevelopment
  def send_email(to_email, body, subject)
    puts "Email sent to #{to_email}\nSubject: #{subject}\nBody: #{body}\n"
  end
end

class Email

  @@gmailSMTP = {
    :address => 'smtp.gmail.com',
    :port => '587',
    :enable_starttls_auto => true,
    :user_name => 'giacomoandvirginia',
    :password => ENV['GMAIL_PASSWORD'],
    :authentication => :plain,
    :domain => "HELO",
  }

  def send_email(to_email, body, subject)
    Pony.mail(:to => to_email, 
              :via => :smtp, 
              :via_options => @@gmailSMTP,
              :subject => subject, 
              :body => body)
  end

end