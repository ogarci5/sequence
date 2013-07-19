get '/clients', :auth => :user do
	@clients = Client.all(:order => :last_name.asc)
	erb :clients
end

post '/clients/create', :auth => :user do
	c = Client.new
	c.first_name = params[:first_name]
	c.last_name = params[:last_name]
	c.address = params[:address]
	c.email = params[:email]
	c.phone = params[:phone]
	c.organization = params[:organization]
	c.special_comment = params[:special_comment]
	c.save
	users = User.all
	users.each do |user| 
		$tube.put({"user" => user, "subject" => c.first_name + " " + c.last_name, "text" => "Client <a href=\"/clients?client=#{c.id}\">#{c.first_name} #{c.last_name}</a> was added."}.to_json)
		message_gen
	end
	redirect back
end

post '/clients/update/:id', :auth => :user do
	c = Client.get(params[:id])
	c.first_name = params[:first_name]
	c.last_name = params[:last_name]
	c.address = params[:address]
	c.email = params[:email]
	c.phone = params[:phone]
	c.organization = params[:organization]
	c.special_comment = params[:special_comment]
	c.save
	redirect back
end

get '/clients/destroy/:id', :auth => :user do
  c = Client.get(params[:id])
	cj = ClientJob.all(:client_id => c.id)
	cj.destroy
  c.destroy
  redirect back
end

get '/clients/:id/notes', :auth => :user do
	@clients = Client.all(:order => :last_name)
  @client = Client.get(params[:id])
	@notes = @client.notes
	erb :client_notes, :layout => (request.xhr? ? false : :layout)
end
