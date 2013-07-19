class Client
	include DataMapper::Resource
	property :id, Serial
	property :first_name, String
	property :last_name, String
	property :address, String
	property :email, String
	property :phone, String
	property :organization, String
	property :special_comment, Text, :lazy => false
	has n, :notes, :child_key => [:client_id]
	has n, :jobs, :through => :client_jobs
end
