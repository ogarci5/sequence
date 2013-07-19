def message_gen
	$messages ||= {}
	while $tube.peek(:ready)
  	job = $tube.reserve
  	users = User.all
  	users.each do |u|
  		if JSON.parse(job.body)["user"]["id"] == u.id
  			if $messages["#{u.id}"].nil?
  				$messages.merge!("#{u.id}" => [JSON.parse(job.body)])
  			else
  				$messages["#{u.id}"] << JSON.parse(job.body)
  			end
  		end
		end
  	job.delete
	end
end
