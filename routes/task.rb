require 'pony'
get '/stories/:id/tasks', :auth => :user do
	@story = Story.get(params[:id])
	@stages = ["Development", "Testing", "Production"]
	@all = params[:all].nil? ? false : params[:all]
	@users = User.all(:order => :name.asc)
	if params[:sort] == "0"
		@tasks = @story.tasks(:order => :name.desc)
	elsif params[:sort] == "1"
		@tasks = @story.tasks(:order => :name.asc)
	elsif params[:sort] == "2"
		@tasks = @story.tasks(:order => :difficulty.asc)
	elsif params[:sort] == "3"
		@tasks = @story.tasks(:order => :difficulty.desc)
	elsif params[:sort] == "4"
		@tasks = @story.tasks(:order => :time_estimate.asc)
	elsif params[:sort] == "5"
		@tasks = @story.tasks(:order => :time_estimate.desc)
	elsif params[:sort] == "6"
		@tasks = @story.tasks(:order => :time_spent.asc)
	elsif params[:sort] == "7"
		@tasks = @story.tasks(:order => :time_spent.desc)
	else
		@tasks = @story.tasks(:order => :name.asc)
	end
	erb :tasks, :layout => (request.xhr? ? false : :layout)
end

get '/tasks/destroy/:id', :auth => :user do
  task_user = TaskUser.all(:task_id => params[:id])
  task_user.destroy
  task = Task.get(params[:id])
	task.destroy
  redirect back
end

post '/stories/:id/tasks/create', :auth => :user do
	t = Task.new
	t.name = params[:name]
	t.description = params[:description]
	t.difficulty = params[:difficulty]
	t.dependency = params[:dependency]
	s = Story.get(params[:id])
	t.story_id = s.id
	t.save
	if !params[:users].nil?
		task_user = TaskUser.all(:task_id => t.id)
    task_user.destroy
		params[:users].each do |user|
			u = User.first(:name => user)
      #send_mail(u.email, "You have been assigned a new task (#{t.name}) for the #{s.name} story.", "Task Name: #{t.name}\nTask Difficulty: #{t.difficulty}\nTask Description: #{t.description}.")
      $tube.put({"user" => u, "subject" => t.name, "text" => "You have been assigned a new task <a href=\"/stories?task=#{t.story.id}&stage=#{s.stage}\">#{t.name}</a> for the #{s.name} story.\nName: #{t.name}\nDifficulty: #{t.difficulty}\nDescription: #{t.description}."}.to_json)
			message_gen
			TaskUser.create(:task_id => t.id, :user_id => u.id)
		end
	end
	redirect back
end

post '/tasks/update/:id', :auth => :user do
	t = Task.get(params[:id])
	t.name = params[:name]
	t.description = params[:description]
	t.difficulty = params[:difficulty]
	t.dependency = params[:dependency]
	t.save
	if !params[:users].nil?
		p t.users
		task_user = TaskUser.all(:task_id => t.id)
    task_user.destroy
		params[:users].each do |user|
			u = User.first(:name => user)
			TaskUser.create(:task_id => t.id, :user_id => u.id)
    end
    p t.users
	else
		task_user = TaskUser.all(:task_id => t.id)
		task_user.destroy
	end
	redirect back
end

post '/partial/task/:id', :auth => :user do
	t = Task.get(params[:id])
	t.completed = params[:checked]
	t.save
	f = File.open('./resources/update.txt', 'a+')
	if params[:checked] == "true"
		if f.lines.count >= 10
			line_arr = File.readlines('./resources/update.txt')
    	line_arr.delete_at(0)
  		File.open('./resources/update.txt', "w") do |file| 
    		line_arr.each{|line| file.puts(line)}
  		end
  		File.open('./resources/update.txt', 'a+') do |file| 
				file.puts "Task <a href=\"/stories?task=#{t.story.id}&stage=#{t.story.stage}\">#{t.name}</a> was completed."
			end
			if t.story.tasks.all(:completed => true).count == t.story.tasks.count
				line_arr = File.readlines('./resources/update.txt')
    		line_arr.delete_at(0)
  			File.open('./resources/update.txt', "w") do |file| 
    			line_arr.each{|line| file.puts(line)}
  			end
  			File.open('./resources/update.txt', 'a+') do |file| 
					file.puts "Story <a href=\"/stories?story=#{t.story.id}&stage=#{t.story.stage}\">#{t.story.name}</a> was completed."
				end
			end
		else
			File.open('./resources/update.txt', 'a+') do |file|
				file.puts "Task <a href=\"/stories?task=#{t.story.id}&stage=#{t.story.stage}\">#{t.name}</a> was completed."
			end
			if t.story.tasks.all(:completed => true).count == t.story.tasks.count
  			File.open('./resources/update.txt', 'a+') do |file| 
					file.puts "Story <a href=\"/stories?story=#{t.story.id}&stage=#{t.story.stage}\">#{t.story.name}</a> was completed."
				end
			end
		end
		t.users.each do |user|
			$tube.put({"user" => user, "subject" => t.name, "text" => "Task <a href=\"/stories?task=#{t.story.id}&stage=#{t.story.stage}\">#{t.name}</a> was completed."}.to_json)
			message_gen
		end
		if t.story.tasks.all(:completed => true).count == t.story.tasks.count
			users = User.all
  		users.each do |user| 
				$tube.put({"user" => user, "subject" => t.story.name, "text" => "Story <a href=\"/stories?story=#{t.story.id}&stage=#{t.story.stage}\">#{t.story.name}</a> was completed."}.to_json)
				message_gen
			end
		end
	end
	redirect back
end
