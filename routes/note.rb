get '/notes', :auth => :user do
	@user = User.first(:name => @authorized_user.name)
	@notes = Note.all(:order => :created_at)
	@clients = Client.all(:order => :last_name)
	erb :notes
end

post '/notes/create', :auth => :user do
	n = Note.new
	n.subject = params[:subject]
	n.body = params[:body]
	n.created_at = Time.now
	u = User.first(:name => @authorized_user.name)
	n.user_id = u.id
	n.category = params[:category]
	client = params[:client].split(" , ")
	c = Client.first(:last_name => client[0], :first_name => client[1])
	n.client_id = c.id
	n.save
	redirect back
end

post '/notes/update/:id', :auth => :user do
	n = Note.get(params[:id])
	n.subject = params[:subject]
	n.body = params[:body]
	n.category = params[:category]
	client = params[:client].split(" , ")
	c = Client.first(:last_name => client[0], :first_name => client[1])
	n.client_id = c.id
	n.save
	redirect back
end

get '/notes/destroy/:id', :auth => :user do
	n = Note.get(params[:id])
	n.destroy
	redirect back
end

get '/partial/note/add', :auth => :user do
	@clients = Client.all(:order => :last_name)
	erb :addnote_partial, :layout => (request.xhr? ? false : :layout)
end

get '/partial/note/remove', :auth => :user do
	erb :removenote_partial, :layout => (request.xhr? ? false : :layout)
end
