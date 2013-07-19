class Note
	include DataMapper::Resource
	property :id, Serial
	property :subject, String
	property :body, Text, :lazy => false
	property :created_at, DateTime
	property :category, String
	belongs_to :client, :child_key => [:client_id]
	belongs_to :user, :child_key => [:user_id]
end
