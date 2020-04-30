class DayController < ApplicationController

  # before do 
    

  #   if !session[:logged_in]
  #     #message
  #     session[:message] = {
  #       success: false,
  #       status: "neutral",
  #       message: "You must be logged in to do that"
  #     }
  #     #redirect
  #     redirect '/users/login'
  #   end

  # end

    get('/') do
      user = User.find_by ({ :username => session[:username] })
      @days = user.days
      
      # getting the average daily calories
      if user.days.exists?
      @avg_cal = user.days.all.average(:calorie).ceil
      end

      @bmr = user.bmr
    
      
      erb :days_home
    end



    get ('/bmr-info') do 
      
      erb :brm_info
    end

    post '/bmr-info' do
      'hello world'
      user = User.find_by ({:username => session[:username]})

      user.gender = params[:gender]
      user.age = params[:age]
      user.height = params[:height]
      user.weight = params[:weight]

      
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



    get ('/:id/edit-account') do
      @user = User.find_by ({ :username => session[:username] })
      erb :edit_account
    end

    put ('/:id') do
      @user = User.find_by ({ :username => session[:username] })
      @user.age = params[:age]
      @user.height = params[:height]
      @user.weight = params[:weidht]
      @user.save

      redirect '/days/'


    end
    
    get('/new') do
    # making it so only logged in users can like posts
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
    
    post('/new') do
      new_day = Day.new
      new_day.name = params[:name]
      if !new_day.name
        session[:message] = {
        success: false,
        status: "bad",
        message: "Please fill out the forms"
        }
        # redirect 
        redirect '/days'
      end
      new_day.time_awake = params[:time]
      if !new_day.time_awake
      session[:message] = {
      success: false,
      status: "bad",
      message: "Please fill out the forms"
      }
      # redirect 
      redirect '/days'
    end

      new_day.task = params[:tasks]
      new_day.food = params[:foods]
      new_day.workout = params[:workout]
      new_day.calorie = params[:calories]
      logged_in_user = User.find_by ({ :username => session[:username] })
      new_day.user_id = logged_in_user.id


      food = new_day.food

      food_arr = food.split(',')

      food_arr =  food_arr.map do | food |
        food.strip
      end

    puts food_arr
    puts "^^^^food arr__-----"
      def total_calories meal
        
        food_obj = {}
        all_food =  Food.all
      
        all_food.each do | food, calorie  |
          food_obj[food.name] = food.calories
        end
        
    meal_calories = meal.map { |food| food_obj[food] }
        total_calories = meal_calories.inject(0, :+)
       
     end

     puts total_calories(food_arr)

     puts "^^^^^^total calories^^^^^^^^^^^^^"

      new_day.save
      redirect '/days'
      end

    get '/:id' do
      @day = Day.find params[:id]
      erb :day_show
    end

    get '/edit/:id' do
      @day = Day.find params[:id]
      erb :edit_day
    end

    put '/edit/:id'  do
      puts 'route hit'
      @day = Day.find params[:id]
      puts @day
      puts 'this is the day^^^^^^^^^^^^^^^^'
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
  
    delete '/:id' do
    day = Day.find params[:id]
    day.destroy

    redirect '/days'
  end


end