get '/account/:current_user/messages', :auth => :user do
	@user = @authorized_user
	erb :account_messages
end

post '/account/message', :auth => :user do
	$messages["#{@authorized_user.id}"].delete($messages["#{@authorized_user.id}"][params[:index].to_i])
	message_gen
	redirect back
end

get '/account/:current_user/profile', :auth => :user do
	@user = @authorized_user
	erb :account_profile
end

get '/account/:current_user/settings', :auth => :user do
		@user = @authorized_user
	erb :account_settings
end

get '/account/:current_user/statistics', :auth => :user do
	@user = @authorized_user
	erb :account_statistics
end

get '/account/:current_user/users', :auth => :admin do
	@user = @authorized_user
	@users = User.all(:order => :last_name)
	erb :account_users
end

post '/account/update/:id', :auth => :user do
	u = User.get(params[:id])
	u.first_name = params[:first_name]
	u.last_name = params[:last_name]
	u.address = params[:address]
	u.email = params[:email]
	u.phone = params[:phone]
	params[:password].nil? == false ? u.password = params[:password] : u.password = u.password
	u.save
	redirect back
end

post '/account/change_password/:id', :auth => :user do
	u = User.get(params[:id])
	u.password = params[:password]
	u.save
	redirect '/sequence'
end

get '/account/email/users' do
	User.all.each do |user|
		body = "Welcome #{user.first_name} #{user.last_name},\n" +
		"\n" +
		"Gtwo Sequence is up and running! You may log in with these credentials.\n" +
		"\n" +
		"\tUsername: #{user.name}\n" +
		"\tPassword: #{user.password}\n" +
		"\n" +
		"Thanks,\n" +
		"Oliver"

		Pony.mail(          :to => user.email,
                            :from => 'sequence@gtwodevelopment.net', 
							:subject => 'Configure your G2 Sequence account',
							:body => body,
							:via => :smtp,
  						:via_options => {
    						:address        => 'mail.gtwodevelopment.net',
    						:port           => '26',
                            :enable_starttls_auto => false,
    						:user_name      => 'sequence+gtwodevelopment.net',
    						:password       => 'sequence!!',
    						:authentication => :plain,
    						:domain         => "localhost.localdomain" 
    					}
  	)

	end
	redirect back
end

get '/partial/account/update/:id', :auth => :user do
	@user_partial = User.get(params[:id])
	erb :account_partial, :layout => (request.xhr? ? false : :layout)
end

get '/partial/account/change_password/:id', :auth => :user do
	@user_partial = User.get(params[:id])
	erb :password_partial, :layout => (request.xhr? ? false : :layout)
end

get '/partial/account/remove/:id', :auth => :user do
	@user_partial = User.get(params[:id])
	erb :removeaccount_partial, :layout => (request.xhr? ? false : :layout)
end

get '/partial/account/add/:id', :auth => :user do
	@user_partial = User.get(params[:id])
	erb :addaccount_partial, :layout => (request.xhr? ? false : :layout)
end

get '/partial/account/remove_password/:id', :auth => :user do
	@user_partial = User.get(params[:id])
	erb :removepassword_partial, :layout => (request.xhr? ? false : :layout)
end

get '/partial/account/add_password/:id', :auth => :user do
	@user_partial = User.get(params[:id])
	erb :addpassword_partial, :layout => (request.xhr? ? false : :layout)
end

post '/partial/account/:id', :auth => :user do
	u = User.get(params[:id])
	u.email_updates = params[:checked]
	u.save
end
