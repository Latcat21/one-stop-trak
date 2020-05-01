class SearchController  < ApplicationController

  get ('/') do
    session[:search] = false
    session[:meals] = false
    erb  :search_page
  end

  get ('/1') do
    search_term = params[:input]
    session[:search_term] = search_term
    session[:meals] = false
   

    uri = URI("https://www.themealdb.com/api/json/v1/1/search.php?s=#{search_term}")
    it = Net::HTTP.get(uri)
    parsed_it = JSON.parse it 
    

    if parsed_it["meals"]
      session[:search] = true
      @meals = parsed_it["meals"]
    else
      session[:seach] = "bad"
    
    end
   
    erb :search_page
  end

  get ('/2') do
    session[:meals] = true
    meal_id = params[:meals]
    uri = URI("https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{meal_id}")
    it = Net::HTTP.get(uri)
    parsed_it = JSON.parse it
    @individual_meal = parsed_it["meals"]
    erb :meal_show
 
  end

  post ('/new') do
    user = User.find_by ({ :username => session[:username] })
    meal_id = params[:meal]
    
    uri = URI("https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{meal_id}")
    it = Net::HTTP.get(uri)
    parsed_it = JSON.parse it
    individual_meal = parsed_it["meals"]

    individual_meal.each do | meal |
      new_meal = Meal.new
      new_meal.name = meal["strMeal"]
      new_meal.img = meal["strMealThumb"]
      new_meal.instructions = meal["strInstructions"]
      
      new_meal.video = meal["strYoutube"]
      new_meal.meal_id = meal["idMeal"]
      new_meal.user_id = user.id
      new_meal.save
    end

    redirect '/search'
  end

  get ('/your-meals') do
    user = User.find_by ({ :username => session[:username]})
    @meals = user.meals

    erb :user_meals
  end

  get '/your-meals/:id' do
    user = User.find_by ({:username => session[:username]})
    @meal = Meal.find params[:id]

    puts '---------------'
    puts @meal
    puts '-----meal---------'

    erb :user_meal_show
  end

  delete '/your-meals/:id' do
    meal = Meal.find params[:id]
    meal.destroy

    redirect '/search/your-meals'

  end

end
