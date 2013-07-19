get '/stories', :auth => :user do
	@stories = Story.all(:order => :created_at.asc)
	@jobs = Job.all(:order => :name.asc)
	@stages = ["Development", "Testing", "Production"]
	erb :stories
end

post '/stories/create', :auth => :user do
	s = Story.new
	s.name = params[:name]
	s.description = params[:description]
	s.created_by = @authorized_user.name
	s.created_at = Time.now
	s.updated_at = Time.now
	j = Job.first(:name => params[:job])
	s.job_id = j.id
	s.stage = params[:stage]
	s.save
	users = User.all
  users.each do |user| 
		$tube.put({"user" => user, "subject" => s.name, "text" => "Story <a href=\"/stories?story=#{s.id}&stage=#{s.stage}\">#{s.name}</a> was created."}.to_json)
		message_gen
	end
	redirect back
end

post '/stories/update/:id', :auth => :user do
	s = Story.get(params[:id])
	s.name = params[:name]
	s.description = params[:description]
	s.updated_at = Time.now
	j = Job.first(:name => params[:job])
	s.job_id = j.id
	stage = s.stage
	s.stage = params[:stage]
	s.save
	if stage != params[:stage]
		users = User.all
		users.each do |user| 
			$tube.put({"user" => user, "subject" => s.name, "text" => "Story <a href=\"/stories?story=#{s.id}&stage=#{s.stage}\">#{s.name}</a> was moved to the #{s.stage} stage."}.to_json)
			message_gen
		end
	end
	redirect back
end

get '/stories/destroy/:id', :auth => :user do
	s = Story.get(params[:id])
	tasks = Task.all(:story_id => params[:id])
	tasks.each do |task|
		tu = TaskUser.all(:task_id => task.id)
		tu.destroy
	end
	tasks.destroy
	s.destroy
	redirect back
end
