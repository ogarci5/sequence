get '/dev', :auth => :admin do

	erb :dev
end

get '/dev/run', :auth => :admin do
	tasks = Task.all
	tasks.each do |t|
		t.dependency = t.story.stage
		t.save
	end
	redirect '/sequence'
end
