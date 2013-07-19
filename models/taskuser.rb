class TaskUser
	include DataMapper::Resource
	property :id, Serial
	belongs_to :user, :child_key => [:user_id]
	belongs_to :task, :child_key => [:task_id]
end
