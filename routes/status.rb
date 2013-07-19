get '/status', :auth => :user do
	erb :status
end
