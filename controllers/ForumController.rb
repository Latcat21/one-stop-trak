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
    new_post.user_id = session[:user_id]

    new_post.save

    redirect '/posts'


  end

end