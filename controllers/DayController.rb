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
      erb :days_home
    end


end