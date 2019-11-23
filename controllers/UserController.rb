class UserController < ApplicationController

  # shows login page
  get '/login' do
    erb :login
  end

 
  post '/login' do
    # find user by username
    user = User.find_by username: params[:username]
    pw = params[:password]

    # if the user exists and password is correct --
    # password is now being checked using bcrypt
    if user && user.authenticate(pw)
      session[:logged_in] = true
      session[:username] = user.username
      session[:message] = {
        success: true,
        status: "good",
        message: "Logged in as #{user.username}"
      }
      redirect '/days'
      else
      # error -- incorrect un or pw
      session[:message] = {
        success: false,
        status: "bad",
        message: "Invalid username or password."
      }
      # redirect to /login so they can reattempt
      redirect '/users/login'
    end
  end

  get '/register' do
    erb :register
  end

 
  post '/register' do
    # check if user exists 
    user = User.find_by username: params[:username]
    # if user doesn't exist
    if !user
    # create user 
    user = User.new
    user.username = params[:username]
    user.password = params[:password]
    if user.password.length <= 8
      session[:logged_in] = false
      session[:message] = {
      success: true,
      status: "bad",
      message: "please enter a password that is 8 or more characters"
      }
      # redirect 
      redirect '/users/register'
    end
    if user.password != params[:passwordtwo]
      session[:logged_in] = false
      session[:message] = {
      success: true,
      status: "bad",
      message: "Passwords do not match up please try again"
      }
      # redirect 
      redirect '/users/register'
    end
    user.age = params[:age]
    user.weight = params[:weight]
    user.height = params[:height]
    user.gender = params[:gender]
    user.save
      
    session[:logged_in] = true
    session[:username] = user.username
    session[:message] = {
      success: true,
      status: "good",
      message: "Welcome to the site, you are now logged in as #{user.username}."
      }
      # redirect to the site
      redirect '/days'
      # else if user does exist
      else 
      # session message -- username taken
      session[:message] = {
        success: false,
        status: "bad",
        message: "Sorry, username #{params[:username]} is already taken."
      }
      # redirect to register so they can try again
      redirect '/users/register'
      end
    end

  
  get '/logout' do
    username = session[:username] # grab username before destroying session...
    #destroying the session
    session.destroy
    session[:message] = {
      success: true,
      status: "neutral",
      message: "User #{username} logged out." 
    }
    redirect '/users/login'
  end

end
