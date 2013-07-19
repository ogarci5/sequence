require 'rubygems'
require 'sinatra'
require 'sinatra/base'
require 'data_mapper'
require 'net/http'
require 'RMagick'
require 'beaneater'
require 'json'

	dir = Dir.pwd
	DataMapper::Logger.new($stdout, :debug)
	DataMapper.setup(:default, 'mysql://root:password@localhost/db')
	require dir+'/models/init.rb'

	DataMapper.finalize.auto_upgrade!

	use Rack::Session::Pool
	
	$beanstalk = Beaneater::Pool.new(['localhost:11300'])
	$beanstalk.tubes.watch("message-tube")
	$tube = $beanstalk.tubes["message-tube"]

	require dir+'/helpers/init.rb'
	require dir+'/routes/init.rb'
