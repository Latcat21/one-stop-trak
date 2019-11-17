require 'sinatra/base'

#controllers
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/DayController'
require './controllers/ForumController'


#models
require './models/UserModel'
require './models/DayModel'
require './models/CommentModel'
require './models/PostModel'


map ('/'){
  run ApplicationController
}

map ('/users'){
  run UserController
}

map ('/days') {
  run DayController
}