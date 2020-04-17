class SearchController  < ApplicationController

  get ('/') do
    session[:search] = false
    erb  :search_page
  end

  get('/1') do
    search_term = params[:input]
    session[:search_term] = search_term
    session[:search] = true

    uri = URI("https://www.themealdb.com/api/json/v1/1/search.php?s=#{search_term}")
    it = Net::HTTP.get(uri)
    parsed_it = JSON.parse it 
    
    meals = parsed_it

    puts meals[:meals]
    puts "---meals^^^^^^^^^^^^^^"

    erb :search_page


  end

end
