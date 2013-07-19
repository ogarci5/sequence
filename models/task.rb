class Task
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	property :description, Text, :lazy => false
	property :time_estimate, Integer
	property :time_spent, Integer
	property :difficulty, Integer
	property :completed, Boolean
	property :dependency, String
	property :status, String
	belongs_to :story, :child_key => [:story_id]
	has n, :users, :through => :task_users
	
	def self.time_left
		return self.time_estimate - self.time_spent
	end
end

