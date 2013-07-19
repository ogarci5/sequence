def send_mail(to, subject, text)
     Pony.mail({
        :to => "#{to}",
        :via => :smtp,
        :via_options => {
        :address        => 'mail.gtwodevelopment.net',
        :port           => '26',
        :enable_starttls_auto => false,
        :user_name      => 'sequence+gtwodevelopment.net',
        :password       => 'sequence!!',
        :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain         => "localhost.localdomain" # the HELO domain provided by the client to the server
    },
        :from => 'sequence@gtwodevelopment.net', 
        :subject => "#{subject}", 
        :body => "#{text}"
    })
end
