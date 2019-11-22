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
      # getting the average daily calories
      @avg_cal = user.days.all.average(:calorie)
     
      
      # bmr calculation
      gender = user.gender
      weight = user.weight
      age = user.age
      height = user.height
      if gender == "male"
        @bmr = 66.47 + (6.24 * weight) + (12.7 * height) - (6.755 * age)
      else 
        @bmr = 655.1 + (4.35 * weight) + (4.7 * height) - (4.7 * age)
      end

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
      @day.task = params[:task]
      @day.food = params[:food]
      @day.workout = params[:workout]
      @day.calorie = params[:calorie]

      @day.save

      redirect '/days/'

    end
  
  delete '/:id' do
    day = Day.find params[:id]
    day.destroy

    session[:message] = {
      success: true, 
      status: "good",
      message: "Successfully delted day ##{day.id}"
    }

    redirect '/days'
  end


end