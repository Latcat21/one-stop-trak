class DayController < ApplicationController

    before do 
      if !session[:logged_in]
          session[:message] = {
          success: false,
          status: "neutral",
          message: "You must be logged in to do that"
        }
      redirect '/users/login'
    end
   end


  # HOME PAGE FOR USERS
    get('/') do
      user = User.find_by ({ :username => session[:username] })
      @days = user.days
      
      # getting the average daily calories AND hours slept
      if user.days.exists?
      @avg_cal = user.days.all.average(:calorie).ceil
      @avg_sleep = user.days.all.average(:sleep).ceil(2)
      end

      @bmr = user.bmr
      erb :days_home
    end


  # BMR PAGE
    get ('/bmr-info') do 
      erb :brm_info
    end

    
  #POST ROUTE FOR CALCULATING THE BMR
    post '/bmr-info' do
     
      user = User.find_by ({:username => session[:username]})
      user.gender = params[:gender]
      user.age = params[:age]
      user.height = params[:height]
      user.weight = params[:weight]

      #DELETING USERS BMR IF IT EXITS
      bmr = user.bmr
      if bmr
      bmr.destroy
      end

      bmr = Bmr.new
      if user.gender == "male"
        bmr.calculation = (4.536 * user.weight) + (15.88 * user.height) - (5 * user.age) + 5
      elsif  user.gender == 'female'
        bmr.calculation = (4.536 * user.weight) + (15.88 * user.height) - (5 * user.age) - 161
      end
      bmr.user_id = user.id
      bmr.save
      redirect '/days'
    
   end
  
   # GET ROUTE OF EDITING THE ACCOUNT
   get ('/:id/edit-account') do
      @user = User.find_by ({ :username => session[:username] })
      erb :edit_account
    end
  #PUT ROUTE FOR EDITING THE ACCOUNT
    put ('/:id') do
      @user = User.find_by ({ :username => session[:username] })
      @user.age = params[:age]
      @user.height = params[:height]
      @user.weight = params[:weidht]
      @user.save

      redirect '/days/'
    end
    

    get('/new') do
    # making it so only logged in users can create a new day
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
      erb :new_day
    end
    
    #POST ROUTE FOR A NEW DAY
    post('/new') do
      new_day = Day.new
      new_day.name = params[:name]
      
      if !new_day.name
        session[:message] = {
        success: false,
        status: "bad",
        message: "Please fill out the forms"
        }
      
        redirect '/days'
      end

      new_day.sleep = params[:hours]
      new_day.food = params[:foods]
      new_day.workout = params[:workout]
      new_day.calorie = params[:calories]
      logged_in_user = User.find_by ({ :username => session[:username] })
      new_day.user_id = logged_in_user.id
      # food = new_day.food
      new_day.save
      redirect '/days'

      # FOR FUTUTUE CALORIE DATABASE

      # food_arr = food.split(',')

      # food_arr =  food_arr.map do | food |
      #   food.strip
      # end

      # def total_calories meal
      #     food_obj = {}
      #     all_food =  Food.all
        
      #     all_food.each do | food, calorie  |
      #       food_obj[food.name] = food.calories
      #     end
          
      #     meal_calories = meal.map { |food| food_obj[food] }
      #     total_calories = meal_calories.inject(0, :+)
      # end
    end

    #GETTING AN INDIVIDUAL DAY
    get '/:id' do
      @day = Day.find params[:id]
      erb :day_show
    end

    #GETTING THE DAY TO BE EDITED
    get '/edit/:id' do
      @day = Day.find params[:id]
      erb :edit_day
    end

    #PUT ROUTE FOR EDIT DAY
    put '/edit/:id'  do
      @day = Day.find params[:id]
      @day.task = params[:task]
      @day.food = params[:food]
      @day.workout = params[:workout]
      @day.calorie = params[:calorie]

     session[:message] = {
        success: false,
        status: "good",
        message: "Day #{@day.id} successfully edited"
        }

      @day.save

      redirect '/days'
    end
  
    #DAY DELETE ROUTE
    delete '/:id' do
      day = Day.find params[:id]
      day.destroy
      redirect '/days'
    end


end