class SearchController  < ApplicationController

  get ('/') do
    session[:search] = false
    session[:meals] = false
    erb  :search_page
  end
  
  # search results for all terms searched
  get ('/1') do
    search_term = params[:input]
    session[:search_term] = search_term
    session[:meals] = false
    uri = URI("https://www.themealdb.com/api/json/v1/1/search.php?s=#{search_term}")
    response = Net::HTTP.get(uri)
    parsed_it = JSON.parse(response) 
    #checking if there were results from the search term
    if parsed_it["meals"]
      session[:search] = true
      @meals = parsed_it["meals"]
    else
      session[:search] = 'bad'
    end
   
    erb :search_page
  end

  # individual meal page
  get ('/2') do
    session[:meals] = true
    search_term = params[:meals]
    uri = URI("https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{search_term}")
    response = Net::HTTP.get(uri)
    parsed_it = JSON.parse(response)
    @individual_meal = parsed_it["meals"]
    erb :meal_show
 end

 #creating/saving the selected meal to the users accound
  post ('/new') do
    user = User.find_by ({ :username => session[:username] })
    meal_id = params[:meal]
    uri = URI("https://www.themealdb.com/api/json/v1/1/lookup.php?i=#{meal_id}")
    response = Net::HTTP.get(uri)
    parsed_it = JSON.parse(response) 
    individual_meal = parsed_it["meals"]

    #looping over the meal and grabing/saving the attributes of that meal
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
