require 'sinatra/base'

#controllers
require './controllers/ApplicationController'
require './controllers/UserController'
require './controllers/DayController'


#models
require './models/UserModel'
require './models/DayModel'
require './models/AverageModel'
require './models/CalorieModel'
require './models/TaskModel'
require './models/FoodModel'
require './models/WorkoutModel'

map ('/'){
  run ApplicationController
}

map ('/users'){
  run UserController
}

map ('/days') {
  run DayController
}