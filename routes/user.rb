post '/users/create', :auth => :user do
	u = User.new
	u.name = params[:name]
	u.password = "sequence"
	u.first_name = params[:first_name]
	u.last_name = params[:last_name]
	u.address = params[:address]
	u.email = params[:email]
	u.phone = params[:phone]
	u.email_updates = false
	u.save
	redirect back
end

post '/users/update/:id', :auth => :user do
	u = User.get(params[:id])
	u.name = params[:name]
	u.first_name = params[:first_name]
	u.last_name = params[:last_name]
	u.address = params[:address]
	u.email = params[:email]
	u.phone = params[:phone]
	u.save
	redirect back
end
