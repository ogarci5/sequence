get '/login' do
	if @authorized_user.nil?
		$login ||= ""
	else
		redirect '/sequence'
	end
	erb :login, :layout => false
end

post '/login' do
	if (User.all.detect {|user| user.name == params[:name] and user.password == params[:password]}) != nil
		user = User.first(:name => params[:name], :password => params[:password])
		if params[:remember] == "on"
			response.set_cookie('user_id', :value => user.id, :expires => (Time.now + 60 * 60 * 24 * 14))
		else
			response.set_cookie('user_id', :value => user.id, :expires => (Time.now + 60 * 60 * 24 * 3))
		end
		$login = ""
		redirect '/sequence'
	else
		$login = "Incorrect username or password."
		redirect back
	end  
end

get '/logout' do
	@authorized_user = nil
	response.set_cookie('user_id', :value => nil)
	redirect '/'
end
