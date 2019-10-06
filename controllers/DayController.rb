class DayController < ApplicationController

  before do 
    puts "filter is running"

    if !session[:logged_in]
      #message
      session[:message] = {
        success: false,
        status: "neutral",
        message: "You must be logged in to do that"
      }
      #redirect
      redirect '/users/login'
    end

  end

    get('/') do
      user = User.find_by ({ :username => session[:username] })
      @days = user.days
      
      erb :days_home
    end
    
    get('/new') do
      erb :new_day
    end
    
    post('/new') do
      new_day = Day.new
      new_day.name = params[:name]
      new_day.wake_up_time = params[:time]
      new_day.task = params[:tasks]
      new_day.food = params[:foods]
      new_day.workout = params[:workout]

      logged_in_user = User.find_by ({ :username => session[:username] })

      new_day.user_id = logged_in_user.id

      new_day.save

      session[:message] = {
        success: true,
        status: "good",
        message: "Successfull created day ##{new_day.id}"
      }

      redirect '/days'


    end

    


    


end