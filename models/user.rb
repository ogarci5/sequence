class User
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	property :password, String
	property :first_name, String
	property :last_name, String
	property :address, String
	property :email, String
	property :phone, String
	property :email_updates, Boolean
	has n, :tasks, :through => :task_users
	has n, :notes, :child_key => [:user_id]
end
