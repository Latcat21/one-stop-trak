class ForumController < ApplicationController

  get ('/') do
    
    @posts = Post.all
    erb :all_post
  end

  get ('/new') do
    erb :new_post
  end

  post ('/new') do
    
    new_post = Post.new
    new_post.title = params[:title]
    new_post.content = params[:content]

    logged_in_user = User.find_by ({ :username => session[:username] })
    new_post.user_id = logged_in_user.id

    new_post.save
    
    redirect '/posts'
    end

    get ('/your-posts') do
      
      user = User.find_by ({ :username => session[:username] })
      @posts = user.posts

      erb :user_posts
    end

end