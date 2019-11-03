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
      new_day.time_awake = params[:time]
      new_day.task = params[:tasks]
      new_day.food = params[:foods]
      new_day.workout = params[:workout]
      new_day.calorie = params[:calories]
      
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

    get '/:id' do
      @day = Day.find params[:id]
      erb :day_show
    end

    get '/:id/edit' do
      @day = Day.find params[:id]
      erb :edit_day
    end

    put '/:id' do
      @day = Day.find params[:id]
      
      
      @day.time_awake = params[:time]
      @day.task = params[:task]
      @day.food = params[:food]
      @day.workout = params[:workout]
      @day.calorie = params[:calorie]

      @day.save

      redirect '/days'

end

end