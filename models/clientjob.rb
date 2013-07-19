class ClientJob
	include DataMapper::Resource
	property :id, Serial
	belongs_to :client, :child_key => [:client_id]
	belongs_to :job, :child_key => [:job_id]
end
