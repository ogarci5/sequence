require 'rubygems'
require 'data_mapper'

	dir = Dir.pwd
	DataMapper::Logger.new($stdout, :debug)
	DataMapper.setup(:default, 'mysql://root:password@localhost/db')
	require dir+'/models/init.rb'

	DataMapper.finalize.auto_upgrade!

users = User.all
user_hsh ||= {}

p users
users.each do |user|
	user_hsh.merge(:name => user.name, :email => user.email)
end

p user_hsh
