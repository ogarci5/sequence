This is Sequence
===========

This will be the backbone of our whole operation at Gtwo Development, we will use it to track everything from job progress to client info.

Config:
software-
  Ruby 1.9.3
  rubygems
  mysql
  ImageMagick
  beanstalkd
libraries-
  FreeType
  libjpeg
  PNG
  libwmf
  Ghostscript
  (make sure to install dependencies)
gems-
  sinatra
  pony
  json
  data_mapper
  dm-mysql-adapter
  beaneater
  Rmagick

To start on our server type in:
  screen ruby main.rb -p 80
in the directory of the repository.

If beanstalkd is not running type in:
  beanstalkd -d

