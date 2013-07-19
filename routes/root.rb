require 'pony'
get '/' do
	erb :home, :layout => false
end

post '/' do
if params[:email].include? "@" and params[:name].size > 0 and params[:inquiry].size > 0
    Pony.mail({
        :to => 'team@gtwodevelopment.net',
        :via => :smtp,
        :via_options => {
        :address        => 'mail.gtwodevelopment.net',
        :port           => '26',
        :enable_starttls_auto => false,
        :user_name      => 'noreply+gtwodevelopment.net',
        :password       => 'n0reply!',
        :authentication => :plain, # :plain, :login, :cram_md5, no auth by default
        :domain         => "localhost.localdomain" # the HELO domain provided by the client to the server
    },
        :from => 'noreply@gtwodevelopment.net', 
        :subject => "#{params[:name]} has sent us an inquiry!", 
        :body => "Name: #{params[:name]}\nRequest: #{params[:inquiry]}\nEmail: #{params[:email]}"
    })
    redirect back
    else
    redirect back
    end
end 

get '/sequence', :auth => :user do
	@updates = IO.readlines('./resources/update.txt')
	erb :index
end

post '/email_team', :auth => :user do
	send_mail("team@gtwodevelopment.net", params[:subject], params[:body])
	redirect back
end

get '/partial/email_team/add', :auth => :user do
	erb :add_email_partial, :layout => (request.xhr? ? false : :layout)
end

get '/partial/email_team/remove', :auth => :user do
	erb :remove_email_partial, :layout => (request.xhr? ? false : :layout)
end

get '/partial/messages', :auth => :user do
	erb :messages, :layout => (request.xhr? ? false : :layout)
end
