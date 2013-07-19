class Story
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	property :description, Text, :lazy => false
	property :created_by, String
	property :created_at, DateTime
	property :updated_at, DateTime
	property :stage, String
	has n, :tasks, :child_key => [:story_id]
	belongs_to :job, :child_key => [:job_id]
	
	def progress
		done ||= 0.0
		total ||= 0.0
		
		self.tasks.each do |task|
		  if task.dependency != self.stage
		  	next
		  end
			total += task.difficulty
		end
		
		self.tasks.all(:completed => true).each do |task|
			if task.dependency != self.stage
		  	next
		  end
			done += task.difficulty
		end
		if total != 0
			return ((done/total)*100).ceil
		else
			return 0
		end
	end
end
