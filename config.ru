require 'sinatra/base'

#controllers
require './controllers/ApplicationController'


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