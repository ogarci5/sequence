class Job
	include DataMapper::Resource
	property :id, Serial
	property :name, String
	property :objective, Text, :lazy => false
	property :payment_type, String
	has n, :stories, :child_key => [:job_id]
	has 1, :invoice, :child_key => [:job_id]
	has n, :clients, :through => :client_jobs
end
