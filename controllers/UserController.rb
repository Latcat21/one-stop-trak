class UserController < ApplicationController
  
  # Shows Login page
  get '/login' do
    erb :login
  end

  #do the login 

  post '/login' do
    #find user by username
    user = User.find_by username: params[:username]

    pw = params[:passord]
  # if user exits and password is correct
    # password is now being checked usin bcrypt
    if user && user.authenticate(pw)
      session[:logged_in] = true
      session[:username] = user.username
      session[:message] = {
        success: true,
        status: "good",
        message: "Logged in as #{user.username}"
      }

      redirect '/days'
    # else 
    else
    # error -- bad username of pw
    session[:message] = {
      success: false,
      status: "bad",
      message: "Invalid username or password"
    }

    #redirect so they can try again
    redirect '/users/login'
    end
  end


  #shows  register page
  get '/register' do
    erb :register
  end

  
  # do registration
  post '/register' do
   
    #check if user exists
    user = User.find_by username: params[:username]
                        # same thing -->({:username => params[:username]})

    #if user doesn't exist
    if !user
      #create user
      user = User.new
      user.username = params[:username]
      #if has_secure passord is specifed in the user model
      # .password= setter method will automatically encrypt the password for you and store is in a field on the  user mode called "password digest"
      user.password = params[:password]
      user.save

    #add stuff to session
    session[:logged_in] = true
    session[:username] = user.username
    session[:message] = {
      success: true,
      status: "good",
      message: "Welcome to the site, you are no logged in as #{user.username}"
    }
      
    #redirect
    redirect '/days'
    #if the user does exist
  else
    #session message --username taken
    session[:message] = {
      success: false,
      status: "bad",
      message: "Sorry, username #{params[:username]} is already taken"
    }
    #redirect to registration
    redirect '/users/register'

  end

  end

  #logout
get '/logout' do
  
  username = session[:username] #grab username before destroying session
  #destroying sessions
  session.destroy

  session[:message] = {
    success: true,
    status: "neutral",
    message: "User #{username} logged out"
  }
  
  redirect '/users/login'




end


end