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
      session[:search] = 'bad'
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
      new_meal = Meal.create(name: meal["strMeal"], img: meal["strMealThumb"], instructions: meal["strInstructions"],video: meal["strYoutube"], meal_id: meal["idMeal"], user_id: user.id )
    end

   session[:message] = {
        success: true,
        status: "good",
        message: "Meal added to your account"
      }
      redirect '/search/your-meals'

  end

  #All users meals
  get ('/your-meals') do
    user = User.find_by ({ :username => session[:username]})
    @meals = user.meals

    erb :user_meals
  end
  #users meal show page route
  get '/your-meals/:id' do
    user = User.find_by ({:username => session[:username]})
    @meal = Meal.find params[:id]
    erb :user_meal_show
  end

  # delete individual meal route
  delete '/your-meals/:id' do
    meal = Meal.find params[:id]
    name = meal.name
    meal.destroy
    session[:message] = {
      success: true,
      status: "good",
      message: "You deleted #{name} from your account"
    }
    redirect '/search/your-meals'

  end

end
