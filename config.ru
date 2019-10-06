require 'sinatra/base'

#controllers
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/DayController'


#models
require './models/UserModel'
require './models/DayModel'
require './models/AverageModel'

map ('/'){
  run ApplicationController
}

map ('/users'){
  run UserController
}

map ('/days') {
  run DayController
}